#include <stdio.h>
#include <stdint.h>
#include <math.h>
#include <stdlib.h>

#define CTX_BITS       32
#define PAD_BITS       2
#define N_BITS         5
#define Y_BITS         3
#define K_BITS         5
#define J_BITS         3
#define ALU_CFG_BITS   3
#define STRIDE_BITS    1
#define S_LDM_BITS     2
#define D_LDM_BITS     2
#define SA_LDM_BITS    6

#define FRACTIONAL_BITS 6
#define SCALE_FACTOR (1 << FRACTIONAL_BITS)

int weight_addr = 0;
int bias_addr = 0;
int ctx_addr = 0;

uint32_t concatenate_to_32bit(int pad, int n, int y, int k, int j, int alu_cfg, int stride, int s_ldm, int d_ldm, int sa_ldm) {
    uint32_t result = 0;
    pad     &= (1 << PAD_BITS) - 1;
    n       &= (1 << N_BITS) - 1;
    y       &= (1 << Y_BITS) - 1;
    k       &= (1 << K_BITS) - 1;
    j       &= (1 << J_BITS) - 1;
    alu_cfg &= (1 << ALU_CFG_BITS) - 1;
    stride  &= (1 << STRIDE_BITS) - 1;
    s_ldm   &= (1 << S_LDM_BITS) - 1;
    d_ldm   &= (1 << D_LDM_BITS) - 1;
    sa_ldm  &= (1 << SA_LDM_BITS) - 1;

    result |= (pad     << (CTX_BITS - PAD_BITS));
    result |= (n       << (CTX_BITS - PAD_BITS - N_BITS));
    result |= (y       << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS));
    result |= (k       << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS));
    result |= (j       << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS));
    result |= (alu_cfg << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS));
    result |= (stride  << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS));
    result |= (s_ldm   << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS - S_LDM_BITS));
    result |= (d_ldm   << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS - S_LDM_BITS - D_LDM_BITS));
    result |= (sa_ldm  << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS - S_LDM_BITS - D_LDM_BITS - SA_LDM_BITS));
    return result;
}

int16_t FX_convert(float input) {
    float scaled_value = input * SCALE_FACTOR;
    int16_t fixed_value;
    if (scaled_value >= 0) fixed_value = (int16_t)(scaled_value + 0.5f);
    else fixed_value = (int16_t)(scaled_value - 0.5f);

    if (fixed_value > 32767) fixed_value = 32767;
    else if (fixed_value < -32768) fixed_value = -32768;
    return fixed_value;
}

void write_weight_to_file(float data[], int length, FILE* weight_file) {
    for (int i = 0; i < length; i++) {
        int data_16bit = FX_convert(data[i]) & 0xFFFF;
        fprintf(weight_file, "%04x_%04x\n", weight_addr++, data_16bit);
    }
}

void write_bias_to_file(float data[], int length, FILE* bias_file) {
    for (int i = 0; i < length; i++) {
        int data_16bit = FX_convert(data[i]) & 0xFFFF;
        fprintf(bias_file, "%04x_%04x\n", bias_addr++, data_16bit);
    }
}

void write_context_to_file(uint32_t data[], int length, FILE* context_file) {
    for (int i = 0; i < length; i++) {
        fprintf(context_file, "%04x_%08x\n", ctx_addr++, data[i]);
    }
}

// Hàm ghi data theo định dạng không có địa chỉ nối kèm (Chuẩn Vivado)
void write_to_file(const char* filename, float data[], int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) return;
    for (int i = 0; i < length; i++) {
        int data_16bit = FX_convert(data[i]) & 0xFFFF;
        fprintf(file, "%04x\n", data_16bit); // In ra "1234" thay vì "0000_1234"
    }
    fclose(file);
}

void write_to_file2(const char* filename, float data[], int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) return;
    for (int i = 0; i < length; i++) {
        int a = i/20;
        int address = (i + a*12) & 0xFFFF;
        int data_16bit = FX_convert(data[i]) & 0xFFFF;
        fprintf(file, "%04x_%04x\n", address, data_16bit);
    }
    fclose(file);
}

float fixedpoint_converter(float value) {
    if(value >= 512) value = value - 512;    
    float scalingFactor = 64.0f;
    return round(value * scalingFactor) / scalingFactor; 
}

void Padding_Conv1D_0(float input_Pad_Conv[320], float output_Pad_Conv[325]){
    write_to_file2("LDM_File.txt", input_Pad_Conv, 340);
    for (int c = 0; c < 1; c++){
        for (int n = 0; n < 325; n++){
            if (n < 2 || n >= 322) output_Pad_Conv[324 * c + n]=0; 
            else output_Pad_Conv[324 * c + n] = input_Pad_Conv[320 * c + n - 2];
        }
    }
    output_Pad_Conv[324] = 0;
}

void Conv1D_0(float Input_Conv[325], float Output_Conv[1280], float bias[8], float kernel[56], FILE* weight_file, FILE* bias_file, FILE* context_file){
    for (int i = 0; i < 324; i++) Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
    for (int i = 0; i < 8; i++) bias[i] = fixedpoint_converter(bias[i]);
    for (int i = 0; i < 56; i++) kernel[i] = fixedpoint_converter(kernel[i]);

    int stride = 2;
    int n, y, k, j;
    Input_Conv[324] = 0;
    
    for (n = 0; n < 8; n++){
        for (y = 0; y < 160; y++){
            float s = 0;
            for (k = 0; k < 1; k++){
                for (j = 0; j < 7; j++){
                    s += (kernel[1*7*n+7*k+j]) * (Input_Conv[324*k+j+y*stride]);
                    s = fixedpoint_converter(s);
                }
            }
            Output_Conv[160*n+y] = s + bias[n];
        }
    }

    for (int i = 0; i < 1280; i++) Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    
    write_to_file("Output_Conv.txt", Output_Conv, 1280);
    write_bias_to_file(bias, 8, bias_file);
    write_weight_to_file(kernel, 56, weight_file);
    
    int pad_ctx = 2, n_ctx = 7, y_ctx = 7, k_ctx = 0, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 1,s_ldm_ctx = 0, d_ldm_ctx = 3, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
    write_context_to_file(&result, 1, context_file);
}

// ==============================================
// HÀM MAIN - CHẠY TEST LAYER 1 VỚI TÍN HIỆU THẬT
// ==============================================
int main() {
    FILE *weight_file = fopen("WRAM_File.txt", "w");
    FILE *bias_file = fopen("BRAM_File.txt", "w");
    FILE *context_file = fopen("CRAM_File.txt", "w");

    if (!weight_file || !bias_file || !context_file) {
        printf("Error: Khong the tao file CRAM/WRAM/BRAM.\n");
        return 1;
    }

    float bias[8];
    float kernel[56];
    float input_Pad_Conv[320];
    float output_Pad_Conv[325];
    float Output_Conv[1280];

    // ĐỌC TÍN HIỆU THẬT TỪ FILE signals.txt
    FILE *sig_file = fopen("signal_HDH.txt", "r");
    if (!sig_file) {
        printf("Error: Khong tim thay file signals.txt. Hay tao file signals.txt cung thu muc.\n");
        return 1;
    }
    float tmp;
    for (int i = 0; i < 320; i++) {
        fscanf(sig_file, "%f", &tmp);
        input_Pad_Conv[i] = tmp;
    }
    fclose(sig_file);

    // Nạp Bias và Weight
    for (int i = 0; i < 8; i++) bias[i] = (i + 1);
    for (int i = 0; i < 56; i++) kernel[i] = 0.0625 + 0.015625 * (i + 1);
    
    // Chạy các hàm của Layer 1
    Padding_Conv1D_0(input_Pad_Conv, output_Pad_Conv);
    Conv1D_0(output_Pad_Conv, Output_Conv, bias, kernel, weight_file, bias_file, context_file);
    
    fclose(weight_file);
    fclose(bias_file);
    fclose(context_file);

    printf("Thanh cong! Da tao file Output_Conv.txt cho Layer 1.\n");
    return 0;
}