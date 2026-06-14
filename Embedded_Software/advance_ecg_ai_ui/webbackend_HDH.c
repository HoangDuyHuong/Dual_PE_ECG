// fpga_ecg_websocket_40pe_fixed.c
// ==============================================================================
// UTE / Dual-PEA 40PE ECG WebSocket backend for KV260 / PetaLinux
// ------------------------------------------------------------------------------
// Build:
//   gcc webbackend.c -o webbackend -O2 $(pkg-config --cflags --libs libwebsockets) -lpthread -lm
//
// Run:
//   ./webbackend
//
// Frontend:
//   ws://<board_ip>:8080
//
// IMPORTANT:
//   This version uses the SAME 40PE LDM layout as the working main.c:
//      hw_addr = (bank << 12) | (local_addr << 6) | pe_idx
//   Final output ctx42 Add2D_2:
//      bank = 0, start_addr = 0, length = 1280 = 32 channels x 40 samples
// ==============================================================================

#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <signal.h>
#include <unistd.h>
#include <pthread.h>
#include <math.h>
#include <time.h>
#include <stdint.h>
#include <libwebsockets.h>

#include "CGRA.h"
#include "FPGA_Driver.c"

typedef uint32_t U32;

#define BILLION                 1000000000ULL

// ---------------- AXI Lite Memory Map ----------------
// Write channel
#define START_BASE              (0x00000)
#define LDM_INPUT_BASE_PHYS     (0x10000 >> 2)
#define CRAM_INPUT_BASE_PHYS    (0x20000 >> 2)
#define WRAM_INPUT_BASE_PHYS    (0x30000 >> 2)
#define BRAM_INPUT_BASE_PHYS    (0x40000 >> 2)

// Read channel
#define DONE_BASE_PHYS          (0x00000)
#define LDM_OUTPUT_BASE_PHYS    (0x10000 >> 2)

// ---------------- Network / fixed-point config ----------------
#define FRACTIONAL_BITS         6
#define SCALE_FACTOR            (1 << FRACTIONAL_BITS)

#define NUM_SAMPLES             100
#define D                       1
#define SEG_LEN                 320

#define PE_NUM                  40
#define LDM_BANKS               4
#define LDM_LOCAL_DEPTH         64
#define INPUT_LDM_WORDS         340

#define CNN_OUT_LEN             1280
#define GAP_LEN                 32
#define NUM_CLASSES             5

#define CRAM_DEPTH              42
#define WRAM_COUNT_EXPECTED     6096
#define BRAM_COUNT_EXPECTED     196
#define DENSE_W_COUNT           160
#define DENSE_B_COUNT           5

#define OUT_LDM_BANK            0
#define OUT_LDM_START_ADDR      0

// Pacing for drawing.
// 1000us = 1ms/sample. Increase if the waveform runs too fast.
#define SAMPLE_DELAY_US         5000

// WebSocket server port. Keep 8080 for now; change later if needed.
#define WS_PORT                 8080

// Vietnamese labels
static const char* VN_LABELS[NUM_CLASSES] = {
    "Bình thường",
    "Ngoại tâm thu trên thất",
    "Ngoại tâm thu thất",
    "Nhịp hợp nhất",
    "Không xác định"
};

static const char* safe_label(int cls)
{
    if (cls >= 0 && cls < NUM_CLASSES) return VN_LABELS[cls];
    return "Không hợp lệ";
}

// ==============================================================================
// WebSocket global state / queue
// ==============================================================================
static volatile int force_exit = 0;
static struct lws_context *context = NULL;

struct ws_msg {
    char *payload;
    size_t len;
    struct ws_msg *next;
};

static pthread_mutex_t q_mutex = PTHREAD_MUTEX_INITIALIZER;
static struct ws_msg *q_head = NULL;
static struct ws_msg *q_tail = NULL;

// Assume single browser client.
static struct lws *g_wsi = NULL;

static void ws_enqueue_payload(char *owned_payload, size_t len)
{
    struct ws_msg *m = (struct ws_msg*)malloc(sizeof(struct ws_msg));
    if (!m) {
        free(owned_payload);
        return;
    }

    m->payload = owned_payload;
    m->len = len;
    m->next = NULL;

    pthread_mutex_lock(&q_mutex);
    if (q_tail) q_tail->next = m;
    else q_head = m;
    q_tail = m;
    pthread_mutex_unlock(&q_mutex);

    if (g_wsi) lws_callback_on_writable(g_wsi);
}

static void send_json_data(const char *type, const char *data_json)
{
    int need = snprintf(NULL, 0, "{\"type\":\"%s\",\"data\":%s}", type, data_json);
    if (need <= 0) return;

    char *s = (char*)malloc((size_t)need + 1);
    if (!s) return;

    snprintf(s, (size_t)need + 1, "{\"type\":\"%s\",\"data\":%s}", type, data_json);
    ws_enqueue_payload(s, (size_t)need);
}

static void send_status(const char *message)
{
    char buf[512];
    snprintf(buf, sizeof(buf), "{\"message\":\"%s\"}", message);
    send_json_data("status", buf);
}

static void send_sample(int beat_id, int index, float value)
{
    char buf[256];
    snprintf(buf, sizeof(buf),
             "{\"beat_id\":%d,\"index\":%d,\"value\":%.6f}",
             beat_id, index, value);
    send_json_data("sample", buf);
}

static void send_beat_start_pending(int beat_id, int beat_start, int gt)
{
    char buf[512];
    snprintf(buf, sizeof(buf),
             "{\"beat_id\":%d,\"beat_start\":%d,"
             "\"gt\":%d,\"gt_label\":\"%s\","
             "\"pred\":-1,\"pred_label\":\"Đang dự đoán...\"}",
             beat_id, beat_start, gt, safe_label(gt));
    send_json_data("beat_start", buf);
}

static void send_beat_pred(int beat_id, int pred, float accuracy, int total, int correct)
{
    char buf[512];
    snprintf(buf, sizeof(buf),
             "{\"beat_id\":%d,"
             "\"pred\":%d,\"pred_label\":\"%s\","
             "\"accuracy\":%.2f,\"total\":%d,\"correct\":%d}",
             beat_id, pred, safe_label(pred), accuracy, total, correct);
    send_json_data("beat_pred", buf);
}

static void send_result(int total, int correct, float accuracy, float exec_time)
{
    char buf[256];
    snprintf(buf, sizeof(buf),
             "{\"total\":%d,\"correct\":%d,\"accuracy\":%.2f,\"time\":%.3f}",
             total, correct, accuracy, exec_time);
    send_json_data("result", buf);
}

static int callback_ecg(struct lws *wsi,
                        enum lws_callback_reasons reason,
                        void *user,
                        void *in,
                        size_t len)
{
    (void)user;
    (void)in;
    (void)len;

    switch (reason) {
        case LWS_CALLBACK_ESTABLISHED:
            printf("WebSocket client connected\n");
            fflush(stdout);
            g_wsi = wsi;
            lws_callback_on_writable(wsi);
            break;

        case LWS_CALLBACK_SERVER_WRITEABLE: {
            struct ws_msg *m = NULL;

            pthread_mutex_lock(&q_mutex);
            if (q_head) {
                m = q_head;
                q_head = q_head->next;
                if (!q_head) q_tail = NULL;
            }
            pthread_mutex_unlock(&q_mutex);

            if (m) {
                unsigned char *buf = (unsigned char*)malloc(LWS_PRE + m->len);
                if (buf) {
                    memcpy(&buf[LWS_PRE], m->payload, m->len);
                    lws_write(wsi, &buf[LWS_PRE], m->len, LWS_WRITE_TEXT);
                    free(buf);
                }

                free(m->payload);
                free(m);

                pthread_mutex_lock(&q_mutex);
                int more = (q_head != NULL);
                pthread_mutex_unlock(&q_mutex);

                if (more) lws_callback_on_writable(wsi);
            }
            break;
        }

        case LWS_CALLBACK_CLOSED:
            printf("WebSocket client disconnected\n");
            fflush(stdout);
            if (g_wsi == wsi) g_wsi = NULL;
            break;

        default:
            break;
    }

    return 0;
}

static struct lws_protocols protocols[] = {
    { "ecg-protocol", callback_ecg, 0, 8192 },
    { NULL, NULL, 0, 0 }
};

// ==============================================================================
// Address / fixed-point helpers -- MATCH working Dual-PEA 40PE main.c
// ==============================================================================
static inline int ldm_addr(int bank, int local_addr, int pe_idx)
{
    return (bank << 12) | (local_addr << 6) | pe_idx;
}

static inline float fixed_point_to_float(U32 fx)
{
    int16_t s_fx = (int16_t)(fx & 0xFFFF);
    return (float)s_fx / (float)SCALE_FACTOR;
}

static inline U32 FX_convert(float x)
{
    float s = x * (float)SCALE_FACTOR;

    if (s > 32767.0f)  s = 32767.0f;
    if (s < -32768.0f) s = -32768.0f;

    int32_t q = (s >= 0.0f) ? (int32_t)(s + 0.5f)
                            : (int32_t)(s - 0.5f);

    return (U32)((int16_t)q & 0xFFFF);
}

static unsigned long long elapsed_ns(struct timespec a, struct timespec b)
{
    return BILLION * (unsigned long long)(b.tv_sec - a.tv_sec) +
           (unsigned long long)(b.tv_nsec - a.tv_nsec);
}

// ==============================================================================
// File loading helpers
// ==============================================================================
static int load_hex_u32_file(const char* path, U32* arr, int max_count, int expected)
{
    FILE* f = fopen(path, "r");
    if (!f) {
        perror(path);
        return -1;
    }

    int count = 0;
    U32 value = 0;
    while (count < max_count && fscanf(f, "%x", &value) == 1) {
        arr[count++] = value;
    }

    fclose(f);

    printf("  %-22s loaded: %d values\n", path, count);
    fflush(stdout);

    if (expected > 0 && count != expected) {
        fprintf(stderr, "ERROR: %s expected %d values, got %d\n", path, expected, count);
        return -1;
    }

    return count;
}

static int load_float_file(const char* path, float* arr, int max_count, int expected)
{
    FILE* f = fopen(path, "r");
    if (!f) {
        perror(path);
        return -1;
    }

    int count = 0;
    float value = 0.0f;
    while (count < max_count && fscanf(f, "%f", &value) == 1) {
        arr[count++] = value;
    }

    fclose(f);

    printf("  %-22s loaded: %d values\n", path, count);
    fflush(stdout);

    if (expected > 0 && count != expected) {
        fprintf(stderr, "ERROR: %s expected %d values, got %d\n", path, expected, count);
        return -1;
    }

    return count;
}

static int load_dataset(const char* path, float* out, int count, const char* what)
{
    FILE* f = fopen(path, "r");
    if (!f) {
        perror(path);
        return -1;
    }

    for (int i = 0; i < count; i++) {
        if (fscanf(f, "%f", &out[i]) != 1) {
            fprintf(stderr, "ERROR: not enough values in %s while reading %s at index %d\n",
                    path, what, i);
            fclose(f);
            return -1;
        }
    }

    fclose(f);
    return 0;
}

// ==============================================================================
// FPGA IO helpers -- MATCH working Dual-PEA 40PE main.c
// ==============================================================================
static void clear_all_ldm(volatile U32* regs)
{
    for (int bank = 0; bank < LDM_BANKS; bank++) {
        for (int local = 0; local < LDM_LOCAL_DEPTH; local++) {
            for (int pe = 0; pe < PE_NUM; pe++) {
                regs[LDM_INPUT_BASE_PHYS + ldm_addr(bank, local, pe)] = 0;
            }
        }
    }
    __sync_synchronize();
}

static void write_input_sample_to_ldm(volatile U32* regs, const float* image)
{
    for (int k = 0; k < INPUT_LDM_WORDS; k++) {
        int pe = k % PE_NUM;
        int local = k / PE_NUM;
        U32 pixel = (k < SEG_LEN) ? FX_convert(image[k]) : FX_convert(0.0f);
        regs[LDM_INPUT_BASE_PHYS + ldm_addr(0, local, pe)] = pixel;
    }

    __sync_synchronize();
}

static int run_accelerator(volatile U32* regs, int sample_idx)
{
    // Same pulse style as the working CLI main.c.
    regs[START_BASE] = 0;
    __sync_synchronize();
    usleep(2);

    regs[START_BASE] = 1;
    __sync_synchronize();

    int timeout = 5000000;
    while (regs[DONE_BASE_PHYS] != 1 && timeout-- > 0) {
        usleep(1);
    }

    if (timeout <= 0) {
        fprintf(stderr, "ERROR: timeout waiting DONE at sample %d\n", sample_idx + 1);
        regs[START_BASE] = 0;
        __sync_synchronize();
        return -1;
    }

    regs[START_BASE] = 0;
    __sync_synchronize();

    return 0;
}

static void read_final_cnn_output(volatile U32* regs,
                                  float* cnn_out,
                                  U32* raw_out,
                                  int out_bank,
                                  int out_start_addr)
{
    for (int j = 0; j < CNN_OUT_LEN; j++) {
        int pe = j % PE_NUM;
        int local = out_start_addr + (j / PE_NUM);
        int addr = ldm_addr(out_bank, local, pe);

        U32 raw = regs[LDM_OUTPUT_BASE_PHYS + addr] & 0xFFFF;
        if (raw_out) raw_out[j] = raw;
        cnn_out[j] = fixed_point_to_float(raw);
    }
}

// ==============================================================================
// Software post-processing -- MATCH working main.c
// ==============================================================================
static void global_average_pool_1d(const float* cnn_out, float* gap_out)
{
    for (int ch = 0; ch < GAP_LEN; ch++) {
        float sum = 0.0f;
        for (int y = 0; y < PE_NUM; y++) {
            sum += cnn_out[ch * PE_NUM + y];
        }
        gap_out[ch] = sum / (float)PE_NUM;
    }
}

static void dense_0(const float* gap_out, const float* weights, const float* bias, float* logits)
{
    for (int cls = 0; cls < NUM_CLASSES; cls++) {
        float s = 0.0f;
        for (int k = 0; k < GAP_LEN; k++) {
            s += gap_out[k] * weights[k * NUM_CLASSES + cls];
        }
        logits[cls] = s + bias[cls];
    }
}

static int argmax5(const float* x)
{
    int idx = 0;
    float best = x[0];

    for (int i = 1; i < NUM_CLASSES; i++) {
        if (x[i] > best) {
            best = x[i];
            idx = i;
        }
    }

    return idx;
}

// ==============================================================================
// FPGA processing thread
// ==============================================================================
static void* fpga_thread(void *arg)
{
    (void)arg;

    printf("Starting FPGA processing...\n");
    fflush(stdout);

    printf("Opening FPGA device...\n");
    fflush(stdout);

    if (fpga_open() == 0) {
        printf("ERROR: Cannot open FPGA device!\n");
        fflush(stdout);
        send_status("ERROR: Cannot open FPGA device");
        return NULL;
    }

    volatile U32* regs = (volatile U32*)MY_IP_info.reg_mmap;

    printf("FPGA opened successfully\n");
    fflush(stdout);
    send_status("FPGA initialized");

    printf("Loading configuration files...\n");
    fflush(stdout);

    U32 CRAM[CRAM_DEPTH] = {0};
    U32 WRAM[WRAM_COUNT_EXPECTED] = {0};
    U32 BRAM[BRAM_COUNT_EXPECTED] = {0};
    float weight_final[DENSE_W_COUNT] = {0.0f};
    float bias_final[DENSE_B_COUNT] = {0.0f};

    if (load_hex_u32_file("CRAM_File.txt", CRAM, CRAM_DEPTH, CRAM_DEPTH) < 0) {
        send_status("ERROR: Cannot load CRAM_File.txt");
        return NULL;
    }

    if (load_hex_u32_file("WRAM_File.txt", WRAM, WRAM_COUNT_EXPECTED, WRAM_COUNT_EXPECTED) < 0) {
        send_status("ERROR: Cannot load WRAM_File.txt");
        return NULL;
    }

    if (load_hex_u32_file("BRAM_File.txt", BRAM, BRAM_COUNT_EXPECTED, BRAM_COUNT_EXPECTED) < 0) {
        send_status("ERROR: Cannot load BRAM_File.txt");
        return NULL;
    }

    if (load_float_file("WRAM_2_File.txt", weight_final, DENSE_W_COUNT, DENSE_W_COUNT) < 0) {
        send_status("ERROR: Cannot load WRAM_2_File.txt");
        return NULL;
    }

    if (load_float_file("BRAM_2_File.txt", bias_final, DENSE_B_COUNT, DENSE_B_COUNT) < 0) {
        send_status("ERROR: Cannot load BRAM_2_File.txt");
        return NULL;
    }

    printf("Writing CRAM/WRAM/BRAM to FPGA registers...\n");
    fflush(stdout);

    for (int j = 0; j < CRAM_DEPTH; j++) {
        regs[CRAM_INPUT_BASE_PHYS + j] = CRAM[j];
    }

    for (int j = 0; j < WRAM_COUNT_EXPECTED; j++) {
        regs[WRAM_INPUT_BASE_PHYS + j] = WRAM[j];
    }

    for (int j = 0; j < BRAM_COUNT_EXPECTED; j++) {
        regs[BRAM_INPUT_BASE_PHYS + j] = BRAM[j];
    }

    __sync_synchronize();

    printf("  CRAM/WRAM/BRAM written\n");
    printf("  CRAM first=0x%08X last=0x%08X\n", CRAM[0], CRAM[CRAM_DEPTH - 1]);
    fflush(stdout);

    send_status("Configuration loaded");

    printf("Loading dataset signal_HDH.txt / label_HDH.txt...\n");
    fflush(stdout);

    float* InModel = (float*)malloc((size_t)NUM_SAMPLES * D * SEG_LEN * sizeof(float));
    float* Label = (float*)malloc((size_t)NUM_SAMPLES * sizeof(float));

    if (!InModel || !Label) {
        send_status("ERROR: malloc failed");
        free(InModel);
        free(Label);
        return NULL;
    }

    if (load_dataset("signal_HDH.txt", InModel, NUM_SAMPLES * D * SEG_LEN, "signals") < 0) {
        send_status("ERROR: Cannot load signal_HDH.txt");
        free(InModel);
        free(Label);
        return NULL;
    }

    if (load_dataset("label_HDH.txt", Label, NUM_SAMPLES, "labels") < 0) {
        send_status("ERROR: Cannot load label_HDH.txt");
        free(InModel);
        free(Label);
        return NULL;
    }

    printf("Dataset loaded: %d beats x %d samples\n", NUM_SAMPLES, SEG_LEN);
    fflush(stdout);
    send_status("Dataset loaded");

    float CNN_output[CNN_OUT_LEN];
    U32 CNN_raw[CNN_OUT_LEN];
    float GlobalAveragePool1D[GAP_LEN];
    float out_Dense[NUM_CLASSES];
    float Image[D * SEG_LEN];

    int correct = 0;
    struct timespec start_total, end_total;
    clock_gettime(CLOCK_REALTIME, &start_total);

    printf("Starting main inference loop for %d beats...\n", NUM_SAMPLES);
    fflush(stdout);

    for (int iimg = 0; iimg < NUM_SAMPLES && !force_exit; iimg++) {
        int beat_id = iimg;
        int startIndex = iimg * D * SEG_LEN;

        for (int k = 0; k < D * SEG_LEN; k++) {
            Image[k] = InModel[startIndex + k];
        }

        int gt = (int)Label[iimg];

        clear_all_ldm(regs);
        write_input_sample_to_ldm(regs, Image);

        if (run_accelerator(regs, iimg) < 0) {
            send_status("ERROR: FPGA timeout");
            break;
        }

        read_final_cnn_output(regs, CNN_output, CNN_raw, OUT_LDM_BANK, OUT_LDM_START_ADDR);

        global_average_pool_1d(CNN_output, GlobalAveragePool1D);
        dense_0(GlobalAveragePool1D, weight_final, bias_final, out_Dense);

        int pred = argmax5(out_Dense);

        if (gt == pred) correct++;
        float accuracy = 100.0f * (float)correct / (float)(iimg + 1);

        printf("Beat %d/%d done inference (GT:%d Pred:%d Acc:%.2f%%)\n",
               iimg + 1, NUM_SAMPLES, gt, pred, accuracy);
        fflush(stdout);

        // 1) Notify frontend a new beat starts, prediction pending.
        send_beat_start_pending(beat_id, iimg * SEG_LEN, gt);

        // 2) Stream waveform samples; reveal prediction after 75% of beat.
        int pred_at = (SEG_LEN * 3) / 4;
        int sent_pred = 0;

        for (int s = 0; s < SEG_LEN && !force_exit; s++) {
            send_sample(beat_id, iimg * SEG_LEN + s, Image[s]);

            if (!sent_pred && s == pred_at) {
                send_beat_pred(beat_id, pred, accuracy, iimg + 1, correct);
                sent_pred = 1;
            }

            usleep(SAMPLE_DELAY_US);
        }

        if (!sent_pred) {
            send_beat_pred(beat_id, pred, accuracy, iimg + 1, correct);
        }
    }

    clock_gettime(CLOCK_REALTIME, &end_total);

    unsigned long long time_total = elapsed_ns(start_total, end_total);
    float final_accuracy = 100.0f * (float)correct / (float)NUM_SAMPLES;

    send_result(NUM_SAMPLES, correct, final_accuracy, (float)time_total / (float)BILLION);

    free(InModel);
    free(Label);

    send_status("Processing complete");
    printf("FPGA processing finished\n");
    fflush(stdout);

    return NULL;
}

// ==============================================================================
// Signal handler / main
// ==============================================================================
static void sighandler(int sig)
{
    (void)sig;
    force_exit = 1;
    if (context) lws_cancel_service(context);
}

int main(void)
{
    struct lws_context_creation_info info;
    pthread_t thread_id;

    signal(SIGINT, sighandler);

    memset(&info, 0, sizeof info);
    info.port = WS_PORT;
    info.protocols = protocols;
    info.gid = -1;
    info.uid = -1;
    info.iface = NULL;  // bind 0.0.0.0

    context = lws_create_context(&info);
    if (!context) {
        fprintf(stderr, "Failed to create WebSocket context\n");
        return 1;
    }

    printf("WebSocket server started on port %d\n", WS_PORT);
    printf("Frontend should connect to ws://<board_ip>:%d using protocol 'ecg-protocol'\n", WS_PORT);
    fflush(stdout);

    if (pthread_create(&thread_id, NULL, fpga_thread, NULL) != 0) {
        fprintf(stderr, "ERROR: pthread_create failed\n");
        lws_context_destroy(context);
        return 1;
    }

    while (!force_exit) {
        lws_service(context, 50);
    }

    pthread_join(thread_id, NULL);
    lws_context_destroy(context);

    pthread_mutex_lock(&q_mutex);
    while (q_head) {
        struct ws_msg *m = q_head;
        q_head = q_head->next;
        free(m->payload);
        free(m);
    }
    q_tail = NULL;
    pthread_mutex_unlock(&q_mutex);

    printf("Server stopped\n");
    return 0;
}
