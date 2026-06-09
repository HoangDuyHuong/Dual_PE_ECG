// ==============================================================================
// TINA (Tiny InceptionNet Accelerator) - DUAL PEA Architecture
// Board: Xilinx Kria KV260
// ==============================================================================

#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdint.h>
#include <math.h>
#include <time.h>
#include <unistd.h>
#include <string.h>

#define BILLION  1000000000

// ================= Memory Map (AXI Lite) =================
#define START_BASE              (0x00000)
#define LDM_INPUT_BASE_PHYS     (0x10000>>2)
#define CRAM_INPUT_BASE_PHYS    (0x20000>>2)
#define WRAM_INPUT_BASE_PHYS    (0x30000>>2)
#define BRAM_INPUT_BASE_PHYS    (0x40000>>2)
#define DONE_BASE_PHYS          (0x00000)
#define LDM_OUTPUT_BASE_PHYS    (0x10000>>2)

// ================= HW Configurations =====================
#define NUM_PE           40     // AXI interface only maps to PEA0's 40 LDMs
#define FINAL_CHANNELS   32     // Final output channels before GAP
#define FRACTIONAL_BITS  6
#define SCALE_FACTOR     (1 << FRACTIONAL_BITS)
#define NumberOfPicture  100
#define d                1
#define SEG_LEN          320

#include "CGRA.h"
#include "FPGA_Driver.c"

// Labels
static const char* VN_LABELS[5] = {"Bình thường", "Ngoại tâm thu trên thất", "Ngoại tâm thu thất", "Nhịp hợp nhất", "Không xác định"};
static const char* EN_LABELS[5] = {"Normal", "Supraventricular", "Ventricular", "Fusion", "Unknown"};

// Helpers
float fixed_point_to_float(U32 fx){
    int16_t s_fx = (int16_t)(fx & 0xFFFF);
    return (float)s_fx / SCALE_FACTOR;
}

U32 FX_convert(float x){
    float s = x * SCALE_FACTOR;
    int16_t f = (s >= 0) ? (int16_t)(s + 0.5f) : (int16_t)(s - 0.5f);
    if (f > 32767) f = 32767;
    else if (f < -32768) f = -32768;
    return (U32)(f & 0xFFFF);
}

void print_progress(int current, int total, int bar_width) {
    float progress = (float)current / total;
    int pos = bar_width * progress;
    printf("\r[");
    for (int i = 0; i < bar_width; ++i) {
        if (i < pos) printf("=");
        else if (i == pos) printf(">");
        else printf(" ");
    }
    printf("] %d/%d (%.1f%%)", current, total, progress * 100.0);
    fflush(stdout);
}

// ==============================================================================
// MAIN ROUTINE
// ==============================================================================
int main(int argc, char** argv){
    const char *signals_path = (argc >= 2) ? argv[1] : "signals.txt";
    const char *labels_path  = (argc >= 3) ? argv[2] : "labels.txt";

    printf("=================================================\n");
    printf("   TINA Dual-PEA ECG Accelerator (KV260 Board)\n");
    printf("=================================================\n\n");

    // ===== 1. FPGA init =====
    printf("[1/5] Initializing FPGA Memory Map...\n");
    if (fpga_open() == 0) {
        fprintf(stderr, "ERROR: Cannot open CGRA device! Did you run with sudo?\n");
        exit(1);
    }
    printf("      ✓ FPGA initialized successfully\n\n");

    // ===== 2. Load configuration files =====
    printf("[2/5] Loading FPGA configuration files...\n");
    FILE *CRAM_file = fopen("CRAM_File.txt", "r");
    FILE *WRAM_file = fopen("WRAM_File.txt", "r");
    FILE *BRAM_file = fopen("BRAM_File.txt", "r");
    FILE *WRAM_2_file = fopen("WRAM_2_File.txt", "r");
    FILE *BRAM_2_file = fopen("BRAM_2_File.txt", "r");

    if(!CRAM_file || !WRAM_file || !BRAM_file || !WRAM_2_file || !BRAM_2_file) { 
        fprintf(stderr, "ERROR: Missing one or more memory .txt files!\n"); return 1; 
    }

    int i = 0; U32 value; float value_f;
    float weight_final[160], bias_final[5];
    U32 CRAM[42], WRAM[6096], BRAM[196];

    while (fscanf(CRAM_file, "%8x", &value) == 1) CRAM[i++] = value; fclose(CRAM_file);
    printf("      ✓ CRAM loaded: %d instructions\n", i);
    
    i=0; while (fscanf(WRAM_file, "%4x", &value) == 1) WRAM[i++] = value; fclose(WRAM_file);
    printf("      ✓ WRAM loaded: %d values (Interleaved Format)\n", i);
    
    i=0; while (fscanf(BRAM_file, "%4x", &value) == 1) BRAM[i++] = value; fclose(BRAM_file);
    printf("      ✓ BRAM loaded: %d values (Interleaved Format)\n", i);

    // Nạp Hardware RAM qua AXI
    for(int j=0; j<42; j++) *(MY_IP_info.reg_mmap + CRAM_INPUT_BASE_PHYS + j) = CRAM[j];
    for(int j=0; j<6096; j++) *(MY_IP_info.reg_mmap + WRAM_INPUT_BASE_PHYS + j) = WRAM[j];
    for(int j=0; j<196; j++) *(MY_IP_info.reg_mmap + BRAM_INPUT_BASE_PHYS + j) = BRAM[j];

    // Nạp Software Array cho Dense Layer
    i=0; while (fscanf(WRAM_2_file, "%f", &value_f) == 1) weight_final[i++] = value_f; fclose(WRAM_2_file);
    i=0; while (fscanf(BRAM_2_file, "%f", &value_f) == 1) bias_final[i++] = value_f; fclose(BRAM_2_file);
    printf("      ✓ Software Dense Layer parameters loaded\n\n");

    // ===== 3. Load dataset =====
    printf("[3/5] Loading dataset...\n");
    float* InModel = (float*)malloc(NumberOfPicture * d * SEG_LEN * sizeof(float));
    float tmp;
    FILE* Input = fopen(signals_path, "r");
    if(!Input){ perror("ERROR"); return 1; }
    for(int k=0; k<NumberOfPicture*d*SEG_LEN; k++){
        fscanf(Input, "%f", &tmp); InModel[k]=tmp;
    }
    fclose(Input);

    float* Label = (float*)malloc(NumberOfPicture * sizeof(float));
    FILE* Output = fopen(labels_path, "r");
    for(int k=0; k<NumberOfPicture; k++){
        fscanf(Output, "%f", &tmp); Label[k]=tmp;
    }
    fclose(Output);
    printf("      ✓ Dataset loaded: %d samples\n\n", NumberOfPicture);

    // ===== 4. Prepare inference =====
    float* OutArray = (float*)malloc(NumberOfPicture * sizeof(float));
    float CNN_output[FINAL_CHANNELS * NUM_PE]; // 32 * 40 = 1280
    float GlobalAveragePool1D[FINAL_CHANNELS];
    float out_Dense[5];
    U32 Pixel[340];
    
    struct timespec t0, t1, start_total, end_total;
    unsigned long long time_spent_CNN = 0;
    int correct = 0;
    int confusion[5][5] = {0};

    printf("[4/5] Running Dual-PEA Inference on FPGA...\n");
    clock_gettime(CLOCK_REALTIME, &start_total);

    for(int iimg=0; iimg<NumberOfPicture; iimg++){
        // Convert to fixed point
        int startIndex = iimg * SEG_LEN;
        for(int k=0; k<340; k++){
            Pixel[k] = (k < SEG_LEN) ? FX_convert(InModel[startIndex+k]) : FX_convert(0.0f);
        }

        // Bắt đầu tính giờ HW
        clock_gettime(CLOCK_REALTIME, &t0);
     
        // 4.1 Write input to LDM (Ghi vào 40 LDMs của PEA0)
        for(int k=0; k<SEG_LEN; k++) {
            int pe_idx = k % NUM_PE;
            int local_addr = k / NUM_PE; 
            int hw_addr = (pe_idx << 6) | local_addr; 
            *(MY_IP_info.reg_mmap + LDM_INPUT_BASE_PHYS + hw_addr) = Pixel[k];
        }  

        // 4.2 Start Hardware
        *(MY_IP_info.reg_mmap + START_BASE) = 1;
        while(*(MY_IP_info.reg_mmap + DONE_BASE_PHYS) != 1) {
            usleep(10); // Polling delay
        }
        
        // 4.3 Read output từ LDM (32 channels)
        for (int channel = 0; channel < FINAL_CHANNELS; channel++) {
            for (int pe_idx = 0; pe_idx < NUM_PE; pe_idx++) {
                int local_addr = channel;
                int hw_addr = (pe_idx << 6) | local_addr;
                int16_t raw_16bit = *(MY_IP_info.reg_mmap + LDM_OUTPUT_BASE_PHYS + hw_addr);
                CNN_output[channel * NUM_PE + pe_idx] = fixed_point_to_float((U32)raw_16bit);
            }
        }

        // Kết thúc tính giờ HW
        clock_gettime(CLOCK_REALTIME, &t1);
        time_spent_CNN += BILLION*(t1.tv_sec - t0.tv_sec) + (t1.tv_nsec - t0.tv_nsec);

        // 4.4 Software Post-Processing (GAP & Dense)
        for(int j=0; j<FINAL_CHANNELS; j++){
            float avg = 0;
            for(int k=0; k<NUM_PE; k++) avg += CNN_output[NUM_PE*j+k];
            GlobalAveragePool1D[j] = avg / (float)NUM_PE;
        }

        int pred = 0; float best = -9999.0f;
        for(int j=0; j<5; j++){
            float s = 0;
            for(int k=0; k<FINAL_CHANNELS; k++) s += GlobalAveragePool1D[k]*weight_final[k*5 + j];
            out_Dense[j] = s + bias_final[j];
            if(out_Dense[j] > best) { best = out_Dense[j]; pred = j; }
        }
        
        OutArray[iimg] = (float)pred;
        int gt = (int)Label[iimg];
        if (gt == pred) correct++;
        if (gt >= 0 && gt < 5 && pred >= 0 && pred < 5) confusion[gt][pred]++;

        if ((iimg+1) % 10 == 0 || iimg == NumberOfPicture-1)
            print_progress(iimg+1, NumberOfPicture, 40);
    }

    clock_gettime(CLOCK_REALTIME, &end_total);
    unsigned long long time_total = BILLION*(end_total.tv_sec - start_total.tv_sec) + (end_total.tv_nsec - start_total.tv_nsec);
    
    printf("\n      ✓ Inference completed\n\n");

    // ===== 5. Display results =====
    printf("[5/5] Results:\n");
    printf("=================================================\n");
    printf("  Overall Accuracy: %.2f%% (%d/%d correct)\n", 100.0 * correct / NumberOfPicture, correct, NumberOfPicture);
    printf("=================================================\n\n");

    printf("Timing Statistics (TINA DUAL-PEA):\n");
    printf("-------------------------------------------------\n");
    printf("  Total execution time:    %.3f s\n", (double)time_total/BILLION);
    printf("  Hardware CNN time:       %.3f s\n", (double)time_spent_CNN/BILLION);
    printf("  Average time per sample: %.3f ms\n", (double)time_spent_CNN/BILLION/NumberOfPicture*1000.0);
    printf("  Hardware Throughput:     %.1f samples/sec\n", NumberOfPicture/((double)time_spent_CNN/BILLION));
    printf("-------------------------------------------------\n\n");

    free(InModel); free(Label); free(OutArray);
    return 0;
}