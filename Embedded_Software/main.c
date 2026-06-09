// ==============================================================================
// TINA / Dual-PEA 40PE ECG full-network runner for KV260 / PetaLinux
// ------------------------------------------------------------------------------
// Compile:
//   gcc main_dual_40pe.c -o main -O2 -lm
//
// Run:
//   sudo ./main signal_HDH.txt label_HDH.txt 100 1
//
// Args:
//   argv[1] signals file          default: signal_HDH.txt
//   argv[2] labels file           default: label_HDH.txt
//   argv[3] num_samples           default: 100
//   argv[4] clear_ldm_each        default: 1
//   argv[5] output_bank           default: 0
//   argv[6] output_start_addr     default: 0
//
// Notes:
//   - Designed for Dual-PEA 40PE RTL with final ctx42 Add2D_2 output:
//       d_ldm = bank0, sa_ldm = 0, length = 1280.
//   - Uses 40PE LDM layout:
//       hw_addr = (bank << 12) | (local_addr << 6) | pe_idx
//   - Keeps important report/debug outputs:
//       accuracy, timing, throughput, confusion matrix, prediction distribution,
//       per-class metrics, wrong predictions, sample0 CNN/GAP/Dense/Softmax dumps.
// ==============================================================================

#define _DEFAULT_SOURCE

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

#include "CGRA.h"
#include "FPGA_Driver.c"

#define BILLION                 1000000000ULL

// ================= AXI Lite Memory Map =================
// Write channel
#define START_BASE              (0x00000)
#define LDM_INPUT_BASE_PHYS     (0x10000 >> 2)
#define CRAM_INPUT_BASE_PHYS    (0x20000 >> 2)
#define WRAM_INPUT_BASE_PHYS    (0x30000 >> 2)
#define BRAM_INPUT_BASE_PHYS    (0x40000 >> 2)

// Read channel
#define DONE_BASE_PHYS          (0x00000)
#define LDM_OUTPUT_BASE_PHYS    (0x10000 >> 2)

// ================= Fixed-point / Network Config =================
#define FRACTIONAL_BITS         6
#define SCALE_FACTOR            (1 << FRACTIONAL_BITS)

#define PE_NUM                  40
#define LDM_BANKS               4
#define LDM_LOCAL_DEPTH         64

#define SEG_LEN                 320
#define INPUT_LDM_WORDS         340

// Final ctx42 Add2D_2 output: 32 channels x 40 samples = 1280
#define CNN_OUT_LEN             1280
#define GAP_LEN                 32
#define NUM_CLASSES             5

#define CRAM_DEPTH              42
#define WRAM_COUNT_EXPECTED     6096
#define BRAM_COUNT_EXPECTED     196

#define DENSE_W_COUNT           160     // 32 GAP x 5 classes
#define DENSE_B_COUNT           5

#define DEFAULT_NUM_SAMPLES     100

#define DEFAULT_OUT_LDM_BANK        0
#define DEFAULT_OUT_LDM_START_ADDR  0

static const char* VN_LABELS[NUM_CLASSES] = {
    "Binh thuong",
    "Ngoai tam thu tren that",
    "Ngoai tam thu that",
    "Nhip hop nhat",
    "Khong xac dinh"
};

static const char* EN_LABELS[NUM_CLASSES] = {
    "Normal",
    "Supraventricular",
    "Ventricular",
    "Fusion",
    "Unknown"
};

// ------------------------------------------------------------------------------
// Address / fixed-point helpers
// ------------------------------------------------------------------------------
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

// ------------------------------------------------------------------------------
// File loading helpers
// ------------------------------------------------------------------------------
static FILE* fopen_first_existing(const char* a, const char* b, const char* mode, const char** opened_name)
{
    FILE* f = fopen(a, mode);
    if (f) {
        if (opened_name) *opened_name = a;
        return f;
    }

    if (b && b[0]) {
        f = fopen(b, mode);
        if (f) {
            if (opened_name) *opened_name = b;
            return f;
        }
    }

    if (opened_name) *opened_name = a;
    return NULL;
}

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

    if (expected > 0 && count != expected) {
        fprintf(stderr, "ERROR: %s expected %d values, got %d\n", path, expected, count);
        return -1;
    }

    return count;
}

static int load_float_file_exact_fallback(const char* path_a,
                                          const char* path_b,
                                          float* arr,
                                          int max_count,
                                          int expected,
                                          const char* label)
{
    const char* opened = NULL;
    FILE* f = fopen_first_existing(path_a, path_b, "r", &opened);
    if (!f) {
        fprintf(stderr, "ERROR: cannot open %s. Tried: %s", label, path_a);
        if (path_b && path_b[0]) fprintf(stderr, " and %s", path_b);
        fprintf(stderr, "\n");
        return -1;
    }

    int count = 0;
    float value = 0.0f;
    while (count < max_count && fscanf(f, "%f", &value) == 1) {
        arr[count++] = value;
    }

    fclose(f);

    printf("  %-22s loaded: %d values (%s)\n", label, count, opened);

    if (expected > 0 && count != expected) {
        fprintf(stderr, "ERROR: %s expected %d values, got %d\n", opened, expected, count);
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

// ------------------------------------------------------------------------------
// FPGA IO helpers
// ------------------------------------------------------------------------------
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
    // Input is written to bank0, 40 PEs, local rows 0..7 plus zero padding to 340 words.
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
    // Generate a clean start pulse for every sample.
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
    // Final layout: 32 channels x 40 PE values.
    // j = channel*40 + pe
    for (int j = 0; j < CNN_OUT_LEN; j++) {
        int pe = j % PE_NUM;
        int local = out_start_addr + (j / PE_NUM);
        int addr = ldm_addr(out_bank, local, pe);
        U32 raw = regs[LDM_OUTPUT_BASE_PHYS + addr] & 0xFFFF;
        raw_out[j] = raw;
        cnn_out[j] = fixed_point_to_float(raw);
    }
}

// ------------------------------------------------------------------------------
// Software post-processing
// ------------------------------------------------------------------------------
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
    // Keep original dense weight layout: weights[k*5 + class].
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

static void softmax5(const float* in, float* out)
{
    float maxv = in[0];
    for (int i = 1; i < NUM_CLASSES; i++) {
        if (in[i] > maxv) maxv = in[i];
    }

    float sum = 0.0f;
    for (int i = 0; i < NUM_CLASSES; i++) {
        out[i] = expf(in[i] - maxv);
        sum += out[i];
    }

    if (sum < 1e-20f) sum = 1e-20f;
    for (int i = 0; i < NUM_CLASSES; i++) {
        out[i] /= sum;
    }
}

static void vector_stats(const float* x, int n, float* mn, float* mx, float* mean, int* zero, int* neg)
{
    *mn = x[0];
    *mx = x[0];
    *mean = 0.0f;
    *zero = 0;
    *neg = 0;

    for (int i = 0; i < n; i++) {
        if (x[i] < *mn) *mn = x[i];
        if (x[i] > *mx) *mx = x[i];
        *mean += x[i];
        if (x[i] == 0.0f) (*zero)++;
        if (x[i] < 0.0f) (*neg)++;
    }

    *mean /= (float)n;
}

static void dump_vector_txt(const char* path, const float* x, int n)
{
    FILE* f = fopen(path, "w");
    if (!f) {
        perror(path);
        return;
    }

    for (int i = 0; i < n; i++) {
        fprintf(f, "%.6f\n", x[i]);
    }

    fclose(f);
}

static void dump_raw_hex_txt(const char* path, const U32* x, int n)
{
    FILE* f = fopen(path, "w");
    if (!f) {
        perror(path);
        return;
    }

    for (int i = 0; i < n; i++) {
        fprintf(f, "%04x\n", x[i] & 0xFFFF);
    }

    fclose(f);
}

static void print_progress(int current, int total, int bar_width)
{
    float progress = (float)current / (float)total;
    int pos = (int)(bar_width * progress);

    printf("\r[");
    for (int i = 0; i < bar_width; ++i) {
        if (i < pos) printf("=");
        else if (i == pos) printf(">");
        else printf(" ");
    }
    printf("] %d/%d (%.1f%%)", current, total, progress * 100.0f);
    fflush(stdout);
}

static void print_sample_detail(int sample_idx,
                                const float* cnn_out,
                                const float* gap_out,
                                const float* logits,
                                const float* probs,
                                int gt,
                                int pred,
                                FILE* detail_file)
{
    float mn, mx, mean;
    int zero, neg;
    vector_stats(cnn_out, CNN_OUT_LEN, &mn, &mx, &mean, &zero, &neg);

    printf("\n========================================\n");
    printf("Sample #%d - GT: %d (%s), Pred: %d (%s)\n",
           sample_idx + 1,
           gt, (gt >= 0 && gt < NUM_CLASSES) ? EN_LABELS[gt] : "Invalid",
           pred, (pred >= 0 && pred < NUM_CLASSES) ? EN_LABELS[pred] : "Invalid");
    printf("CNN Output: min=%.6f max=%.6f mean=%.6f zero=%d neg=%d\n",
           mn, mx, mean, zero, neg);

    printf("CNN first 10: ");
    for (int i = 0; i < 10; i++) printf("%.4f ", cnn_out[i]);
    printf("\n");

    printf("GAP: ");
    for (int i = 0; i < GAP_LEN; i++) {
        printf("%.4f ", gap_out[i]);
        if ((i + 1) % 8 == 0 && i != GAP_LEN - 1) printf("\n     ");
    }
    printf("\n");

    printf("Dense logits: ");
    for (int i = 0; i < NUM_CLASSES; i++) printf("%.4f ", logits[i]);
    printf("\nSoftmax:      ");
    for (int i = 0; i < NUM_CLASSES; i++) printf("%.6f ", probs[i]);
    printf("\nResult: %s\n", (gt == pred) ? "CORRECT" : "WRONG");
    printf("========================================\n");

    if (detail_file) {
        fprintf(detail_file, "Sample,%d\n", sample_idx + 1);
        fprintf(detail_file, "GroundTruth,%d,%s\n", gt, (gt >= 0 && gt < NUM_CLASSES) ? EN_LABELS[gt] : "Invalid");
        fprintf(detail_file, "Prediction,%d,%s\n", pred, (pred >= 0 && pred < NUM_CLASSES) ? EN_LABELS[pred] : "Invalid");
        fprintf(detail_file, "CNN_Stats,%.6f,%.6f,%.6f,%d,%d\n", mn, mx, mean, zero, neg);

        fprintf(detail_file, "GAP");
        for (int i = 0; i < GAP_LEN; i++) fprintf(detail_file, ",%.6f", gap_out[i]);
        fprintf(detail_file, "\n");

        fprintf(detail_file, "Dense");
        for (int i = 0; i < NUM_CLASSES; i++) fprintf(detail_file, ",%.6f", logits[i]);
        fprintf(detail_file, "\n");

        fprintf(detail_file, "Softmax");
        for (int i = 0; i < NUM_CLASSES; i++) fprintf(detail_file, ",%.6f", probs[i]);
        fprintf(detail_file, "\nCorrect,%s\n---\n", (gt == pred) ? "Yes" : "No");
    }
}

static void write_run_summary(const char* path,
                              int num_samples,
                              int correct,
                              unsigned long long total_ns,
                              unsigned long long fpga_ns_total,
                              int out_bank,
                              int out_start_addr)
{
    FILE* f = fopen(path, "w");
    if (!f) {
        perror(path);
        return;
    }

    double total_s = (double)total_ns / (double)BILLION;
    double fpga_s = (double)fpga_ns_total / (double)BILLION;
    double acc = 100.0 * (double)correct / (double)num_samples;

    fprintf(f, "Metric,Value\n");
    fprintf(f, "Architecture,Dual-PEA 40PE\n");
    fprintf(f, "Samples,%d\n", num_samples);
    fprintf(f, "Correct,%d\n", correct);
    fprintf(f, "Accuracy_percent,%.6f\n", acc);
    fprintf(f, "Total_wall_time_s,%.9f\n", total_s);
    fprintf(f, "FPGA_run_read_time_s,%.9f\n", fpga_s);
    fprintf(f, "Avg_FPGA_time_per_sample_ms,%.9f\n", fpga_s / (double)num_samples * 1000.0);
    fprintf(f, "Throughput_samples_per_s,%.6f\n", (double)num_samples / fpga_s);
    fprintf(f, "Output_bank,%d\n", out_bank);
    fprintf(f, "Output_start_addr,%d\n", out_start_addr);

    fclose(f);
}

// ------------------------------------------------------------------------------
// Main
// ------------------------------------------------------------------------------
int main(int argc, char** argv)
{
    const char* signals_path = (argc >= 2) ? argv[1] : "signal_HDH.txt";
    const char* labels_path  = (argc >= 3) ? argv[2] : "label_HDH.txt";
    int num_samples          = (argc >= 4) ? atoi(argv[3]) : DEFAULT_NUM_SAMPLES;
    int clear_ldm_each       = (argc >= 5) ? atoi(argv[4]) : 1;
    int out_bank             = (argc >= 6) ? atoi(argv[5]) : DEFAULT_OUT_LDM_BANK;
    int out_start_addr       = (argc >= 7) ? atoi(argv[6]) : DEFAULT_OUT_LDM_START_ADDR;

    if (num_samples <= 0) {
        fprintf(stderr, "ERROR: num_samples must be > 0\n");
        return 1;
    }
    if (out_bank < 0 || out_bank >= LDM_BANKS) {
        fprintf(stderr, "ERROR: output bank must be 0..%d\n", LDM_BANKS - 1);
        return 1;
    }
    if (out_start_addr < 0 || out_start_addr + GAP_LEN > LDM_LOCAL_DEPTH) {
        fprintf(stderr, "ERROR: output start address invalid. start=%d, GAP_LEN=%d, LDM_LOCAL_DEPTH=%d\n",
                out_start_addr, GAP_LEN, LDM_LOCAL_DEPTH);
        return 1;
    }

    printf("=================================================\n");
    printf("   TINA Dual-PEA 40PE FPGA ECG Classification\n");
    printf("=================================================\n");
    printf("Board             : Xilinx Kria KV260 / PetaLinux\n");
    printf("Signals file      : %s\n", signals_path);
    printf("Labels file       : %s\n", labels_path);
    printf("Num samples       : %d\n", num_samples);
    printf("Clear LDM/sample  : %d\n", clear_ldm_each);
    printf("Final output LDM  : bank=%d start_addr=%d length=%d\n", out_bank, out_start_addr, CNN_OUT_LEN);
    printf("PE_NUM            : %d\n", PE_NUM);
    printf("CRAM/WRAM/BRAM    : %d / %d / %d\n\n",
           CRAM_DEPTH, WRAM_COUNT_EXPECTED, BRAM_COUNT_EXPECTED);

    printf("[1/5] Opening FPGA device...\n");
    if (fpga_open() == 0) {
        fprintf(stderr, "ERROR: Cannot open CGRA device! Try sudo, and check UIO/device mapping.\n");
        return 1;
    }

    volatile U32* regs = (volatile U32*)MY_IP_info.reg_mmap;
    printf("      FPGA opened successfully.\n\n");

    printf("[2/5] Loading memory/configuration files...\n");

    U32 CRAM[CRAM_DEPTH] = {0};
    U32 WRAM[WRAM_COUNT_EXPECTED] = {0};
    U32 BRAM[BRAM_COUNT_EXPECTED] = {0};
    float dense_w[DENSE_W_COUNT] = {0.0f};
    float dense_b[DENSE_B_COUNT] = {0.0f};

    if (load_hex_u32_file("CRAM_File.txt", CRAM, CRAM_DEPTH, CRAM_DEPTH) < 0) return 1;
    if (load_hex_u32_file("WRAM_File.txt", WRAM, WRAM_COUNT_EXPECTED, WRAM_COUNT_EXPECTED) < 0) return 1;
    if (load_hex_u32_file("BRAM_File.txt", BRAM, BRAM_COUNT_EXPECTED, BRAM_COUNT_EXPECTED) < 0) return 1;

    if (load_float_file_exact_fallback("WRAM_2_File.txt", "WRAM_2-File.txt",
                                       dense_w, DENSE_W_COUNT, DENSE_W_COUNT, "Dense weights") < 0) return 1;

    if (load_float_file_exact_fallback("BRAM_2_File.txt", "BRAM_2-File.txt",
                                       dense_b, DENSE_B_COUNT, DENSE_B_COUNT, "Dense biases") < 0) return 1;

    printf("\n      Writing CRAM/WRAM/BRAM to FPGA...\n");
    for (int i = 0; i < CRAM_DEPTH; i++) {
        regs[CRAM_INPUT_BASE_PHYS + i] = CRAM[i];
    }
    for (int i = 0; i < WRAM_COUNT_EXPECTED; i++) {
        regs[WRAM_INPUT_BASE_PHYS + i] = WRAM[i];
    }
    for (int i = 0; i < BRAM_COUNT_EXPECTED; i++) {
        regs[BRAM_INPUT_BASE_PHYS + i] = BRAM[i];
    }
    __sync_synchronize();

    printf("      CRAM first=0x%08X last=0x%08X\n\n", CRAM[0], CRAM[CRAM_DEPTH - 1]);

    printf("[3/5] Loading dataset...\n");

    float* signals = (float*)malloc((size_t)num_samples * SEG_LEN * sizeof(float));
    float* labels = (float*)malloc((size_t)num_samples * sizeof(float));
    float* predictions = (float*)malloc((size_t)num_samples * sizeof(float));

    if (!signals || !labels || !predictions) {
        fprintf(stderr, "ERROR: malloc dataset buffers failed\n");
        free(signals);
        free(labels);
        free(predictions);
        return 1;
    }

    if (load_dataset(signals_path, signals, num_samples * SEG_LEN, "signals") < 0) {
        free(signals); free(labels); free(predictions);
        return 1;
    }
    if (load_dataset(labels_path, labels, num_samples, "labels") < 0) {
        free(signals); free(labels); free(predictions);
        return 1;
    }

    printf("      Signals loaded: %d samples x %d points\n", num_samples, SEG_LEN);
    printf("      Labels loaded : %d labels\n\n", num_samples);

    FILE* detail_file = fopen("detailed_outputs.csv", "w");
    if (detail_file) {
        fprintf(detail_file, "# sample detail output\n");
    }

    FILE* results_file = fopen("classification_results.csv", "w");
    if (results_file) {
        fprintf(results_file, "Sample,GroundTruth,Prediction,GroundTruth_Label,Prediction_Label,Correct");
        for (int i = 0; i < NUM_CLASSES; i++) fprintf(results_file, ",Logit%d", i);
        for (int i = 0; i < NUM_CLASSES; i++) fprintf(results_file, ",Prob%d", i);
        fprintf(results_file, "\n");
    }

    FILE* wrong_file = fopen("wrong_predictions.csv", "w");
    if (wrong_file) {
        fprintf(wrong_file, "Sample,GroundTruth,Prediction,GroundTruth_Label,Prediction_Label");
        for (int i = 0; i < NUM_CLASSES; i++) fprintf(wrong_file, ",Logit%d", i);
        fprintf(wrong_file, "\n");
    }

    float image[SEG_LEN];
    float cnn_out[CNN_OUT_LEN];
    U32 cnn_raw[CNN_OUT_LEN];
    float gap_out[GAP_LEN];
    float logits[NUM_CLASSES];
    float probs[NUM_CLASSES];

    int confusion[NUM_CLASSES][NUM_CLASSES] = {{0}};
    int pred_count[NUM_CLASSES] = {0};
    int gt_count[NUM_CLASSES] = {0};
    int correct = 0;

    struct timespec t_total0, t_total1;
    unsigned long long fpga_ns_total = 0;

    printf("[4/5] Running inference on Dual-PEA 40PE accelerator...\n");
    clock_gettime(CLOCK_REALTIME, &t_total0);

    for (int sample = 0; sample < num_samples; sample++) {
        memcpy(image, &signals[(size_t)sample * SEG_LEN], SEG_LEN * sizeof(float));

        if (clear_ldm_each) {
            clear_all_ldm(regs);
        }

        write_input_sample_to_ldm(regs, image);

        struct timespec t0, t1;
        clock_gettime(CLOCK_REALTIME, &t0);

        if (run_accelerator(regs, sample) < 0) {
            free(signals);
            free(labels);
            free(predictions);
            if (detail_file) fclose(detail_file);
            if (results_file) fclose(results_file);
            if (wrong_file) fclose(wrong_file);
            return 1;
        }

        read_final_cnn_output(regs, cnn_out, cnn_raw, out_bank, out_start_addr);

        clock_gettime(CLOCK_REALTIME, &t1);
        fpga_ns_total += elapsed_ns(t0, t1);

        global_average_pool_1d(cnn_out, gap_out);
        dense_0(gap_out, dense_w, dense_b, logits);
        softmax5(logits, probs);

        int pred = argmax5(logits);
        int gt = (int)labels[sample];
        predictions[sample] = (float)pred;

        if (gt >= 0 && gt < NUM_CLASSES) gt_count[gt]++;
        if (pred >= 0 && pred < NUM_CLASSES) pred_count[pred]++;

        if (gt >= 0 && gt < NUM_CLASSES && pred >= 0 && pred < NUM_CLASSES) {
            confusion[gt][pred]++;
        }

        if (gt == pred) {
            correct++;
        }

        if (sample == 0) {
            dump_raw_hex_txt("sample0_cnn_output_board_hex.txt", cnn_raw, CNN_OUT_LEN);
            dump_vector_txt("sample0_cnn_output_board.txt", cnn_out, CNN_OUT_LEN);
            dump_vector_txt("sample0_gap_board.txt", gap_out, GAP_LEN);
            dump_vector_txt("sample0_dense_logits_board.txt", logits, NUM_CLASSES);
            dump_vector_txt("sample0_softmax_board.txt", probs, NUM_CLASSES);
        }

        if (sample < 5 || gt != pred) {
            print_sample_detail(sample, cnn_out, gap_out, logits, probs, gt, pred,
                                (sample < 5) ? detail_file : NULL);
        }

        if (results_file) {
            fprintf(results_file, "%d,%d,%d,%s,%s,%s",
                    sample + 1,
                    gt,
                    pred,
                    (gt >= 0 && gt < NUM_CLASSES) ? EN_LABELS[gt] : "Invalid",
                    (pred >= 0 && pred < NUM_CLASSES) ? EN_LABELS[pred] : "Invalid",
                    (gt == pred) ? "Yes" : "No");
            for (int i = 0; i < NUM_CLASSES; i++) fprintf(results_file, ",%.6f", logits[i]);
            for (int i = 0; i < NUM_CLASSES; i++) fprintf(results_file, ",%.6f", probs[i]);
            fprintf(results_file, "\n");
        }

        if (wrong_file && gt != pred) {
            fprintf(wrong_file, "%d,%d,%d,%s,%s",
                    sample + 1,
                    gt,
                    pred,
                    (gt >= 0 && gt < NUM_CLASSES) ? EN_LABELS[gt] : "Invalid",
                    (pred >= 0 && pred < NUM_CLASSES) ? EN_LABELS[pred] : "Invalid");
            for (int i = 0; i < NUM_CLASSES; i++) fprintf(wrong_file, ",%.6f", logits[i]);
            fprintf(wrong_file, "\n");
        }

        if ((sample + 1) % 10 == 0 || sample == num_samples - 1) {
            print_progress(sample + 1, num_samples, 40);
        }
    }

    clock_gettime(CLOCK_REALTIME, &t_total1);
    printf("\n      Inference completed.\n\n");

    if (detail_file) fclose(detail_file);
    if (results_file) fclose(results_file);
    if (wrong_file) fclose(wrong_file);

    unsigned long long total_ns = elapsed_ns(t_total0, t_total1);

    double total_s = (double)total_ns / (double)BILLION;
    double fpga_s = (double)fpga_ns_total / (double)BILLION;
    double acc = 100.0 * (double)correct / (double)num_samples;

    printf("[5/5] Results\n");
    printf("=================================================\n");
    printf("Overall Accuracy: %.2f%% (%d/%d correct)\n",
           acc, correct, num_samples);
    printf("=================================================\n\n");

    printf("Ground-truth Distribution:\n");
    for (int i = 0; i < NUM_CLASSES; i++) {
        printf("  Class %d (%s): %d\n", i, EN_LABELS[i], gt_count[i]);
    }
    printf("\n");

    printf("Prediction Distribution:\n");
    for (int i = 0; i < NUM_CLASSES; i++) {
        printf("  Class %d (%s): %d\n", i, EN_LABELS[i], pred_count[i]);
    }
    printf("\n");

    printf("Confusion Matrix (Rows=GT, Cols=Pred):\n");
    printf("      ");
    for (int j = 0; j < NUM_CLASSES; j++) printf("%6d", j);
    printf("\n");
    for (int i = 0; i < NUM_CLASSES; i++) {
        printf("%3d | ", i);
        for (int j = 0; j < NUM_CLASSES; j++) {
            printf("%6d", confusion[i][j]);
        }
        printf("   %s\n", EN_LABELS[i]);
    }
    printf("\n");

    printf("Per-class Metrics:\n");
    printf("  Class | Label                 | Recall/Acc       | Precision       | F1\n");
    printf("  ------+-----------------------+------------------+-----------------+----------\n");
    for (int cls = 0; cls < NUM_CLASSES; cls++) {
        int tp = confusion[cls][cls];

        int total_gt = 0;
        for (int p = 0; p < NUM_CLASSES; p++) total_gt += confusion[cls][p];

        int total_pred = 0;
        for (int g = 0; g < NUM_CLASSES; g++) total_pred += confusion[g][cls];

        double recall = (total_gt > 0) ? (double)tp / (double)total_gt : 0.0;
        double precision = (total_pred > 0) ? (double)tp / (double)total_pred : 0.0;
        double f1 = (precision + recall > 0.0) ? 2.0 * precision * recall / (precision + recall) : 0.0;

        printf("  %5d | %-21s | %6.2f%% (%d/%d) | %6.2f%% (%d/%d) | %6.2f%%\n",
               cls,
               VN_LABELS[cls],
               recall * 100.0, tp, total_gt,
               precision * 100.0, tp, total_pred,
               f1 * 100.0);
    }
    printf("\n");

    printf("Timing Statistics (Dual-PEA 40PE):\n");
    printf("-------------------------------------------------\n");
    printf("  Total wall time          : %.3f s\n", total_s);
    printf("  FPGA run+read time       : %.3f s\n", fpga_s);
    printf("  Avg FPGA time/sample     : %.3f ms\n", (fpga_s / (double)num_samples) * 1000.0);
    printf("  End-to-end avg/sample    : %.3f ms\n", (total_s / (double)num_samples) * 1000.0);
    printf("  FPGA throughput          : %.1f samples/s\n", (double)num_samples / fpga_s);
    printf("  End-to-end throughput    : %.1f samples/s\n", (double)num_samples / total_s);
    printf("-------------------------------------------------\n\n");

    write_run_summary("run_summary.csv", num_samples, correct, total_ns, fpga_ns_total,
                      out_bank, out_start_addr);

    printf("Output files:\n");
    printf("  classification_results.csv\n");
    printf("  wrong_predictions.csv\n");
    printf("  detailed_outputs.csv\n");
    printf("  run_summary.csv\n");
    printf("  sample0_cnn_output_board_hex.txt\n");
    printf("  sample0_cnn_output_board.txt\n");
    printf("  sample0_gap_board.txt\n");
    printf("  sample0_dense_logits_board.txt\n");
    printf("  sample0_softmax_board.txt\n");

    free(signals);
    free(labels);
    free(predictions);

    printf("\nDone.\n");
    return 0;
}
