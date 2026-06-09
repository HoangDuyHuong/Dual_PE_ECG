#include <cmath>  // Include cmath for the round function
#include <cstdio>
#include <stdio.h>
#include <math.h>
#include <stdint.h>

// Define bit lengths as macros
#define CTX_BITS       32  // Total bits in the final result
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

#define NUM_VALUES 1280
#define FRACTIONAL_BITS 6
#define SCALE_FACTOR (1 << FRACTIONAL_BITS)

int weight_addr = 0;
int bias_addr = 0;
int ctx_addr = 0;

FILE *weight_file = fopen("WRAM_File.txt", "w");
FILE *bias_file = fopen("BRAM_File.txt", "w");
FILE *context_file = fopen("CRAM_File.txt", "w");
FILE *file1 = fopen("WRAM_2_File.txt", "w");	
FILE *file2 = fopen("BRAM_2_File.txt", "w");
// Function to concatenate inputs into a 32-bit integer
uint32_t concatenate_to_32bit(int pad, int n, int y, int k, int j, int alu_cfg, int stride, int s_ldm, int d_ldm, int sa_ldm) {
    uint32_t result = 0;

    // Ensure inputs are within their respective bit limits
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

    // Concatenate the inputs into a single 32-bit integer
    result |= (pad     << (CTX_BITS - PAD_BITS));                                 // Pad bits
    result |= (n       << (CTX_BITS - PAD_BITS - N_BITS));                        // N bits
    result |= (y       << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS));               // Y bits
    result |= (k       << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS));      // K bits
    result |= (j       << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS));  // J bits
    result |= (alu_cfg << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS));  // ALU CFG bits
    result |= (stride  << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS));  // Stride bits
    result |= (s_ldm   << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS - S_LDM_BITS));  // S_LDM bits
    result |= (d_ldm   << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS - S_LDM_BITS - D_LDM_BITS));  // D_LDM bit
    result |= (sa_ldm  << (CTX_BITS - PAD_BITS - N_BITS - Y_BITS - K_BITS - J_BITS - ALU_CFG_BITS - STRIDE_BITS - S_LDM_BITS - D_LDM_BITS - SA_LDM_BITS));  // SA_LDM bits

    return result;
}

// Define the scale factor for 6 fractional bits
#define FRACTIONAL_BITS 6
#define SCALE_FACTOR (1 << FRACTIONAL_BITS)

// Function to convert float to 16-bit fixed-point (1 sign bit, 9 integer bits, 6 fractional bits)
int16_t FX_convert(float input) {
    // Multiply the input by the scale factor
    float scaled_value = input * SCALE_FACTOR;

    // Proper rounding towards zero for negative numbers
    int16_t fixed_value;
    if (scaled_value >= 0) {
        fixed_value = (int16_t)(scaled_value + 0.5f);  // Round up for positive values
    } else {
        fixed_value = (int16_t)(scaled_value - 0.5f);  // Round down for negative values
    }

    // Handle overflow and underflow cases explicitly within 16-bit range
    if (fixed_value > 32767) {
        fixed_value = 32767;
    } else if (fixed_value < -32768) {
        fixed_value = -32768;
    }

    // Return the fixed-point value
    return fixed_value;
}

// Function to write data to file in "address_data" format
void write_weight_to_file(float data[], int length, int N) {
    int KJ = length / N;
    for (int p = 0; p < N / 2; p++) {
        for (int kj = 0; kj < KJ; kj++) {
            // Channel cho PEA 0 (Số chẵn)
            int idx0 = (2 * p) * KJ + kj;
            fprintf(weight_file, "%04x\n", FX_convert(data[idx0]) & 0xFFFF);
            weight_addr++;

            // Channel cho PEA 1 (Số lẻ)
            int idx1 = (2 * p + 1) * KJ + kj;
            fprintf(weight_file, "%04x\n", FX_convert(data[idx1]) & 0xFFFF);
            weight_addr++;
        }
    }
}

void write_bias_to_file(float data[], int length) {
    int N = length;
    for (int p = 0; p < N / 2; p++) {
        // Bias cho PEA 0
        fprintf(bias_file, "%04x\n", FX_convert(data[2 * p]) & 0xFFFF);
        bias_addr++;
        
        // Bias cho PEA 1
        fprintf(bias_file, "%04x\n", FX_convert(data[2 * p + 1]) & 0xFFFF);
        bias_addr++;
    }
}

// Function to write data to file in "address_data" format
void write_context_to_file(uint32_t data[], int length) {
    for (int i = 0; i < length; i++) {        
        fprintf(context_file, "%08x\n", data[i]);
		ctx_addr++;
    }
	
}
// Function to write data to file in "address_data" format
void write_to_file(const char* filename, float data[], int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error: Unable to open file %s for writing.\n", filename);
        return;
    }

    for (int i = 0; i < length; i++) {
        int fixed_point_value = FX_convert(data[i]);
        // Ensure 16-bit representation of the address and data
	
        int address = (i) & 0xFFFF; // Mask to 16-bit address
		// printf("address = %d\n",address);
        int data_16bit = fixed_point_value & 0xFFFF; // Mask to 16-bit data
        
        fprintf(file, "%04x_%04x\n", address, data_16bit);
    }

    fclose(file);
}

// Function to write data to file in "address_data" format
void write_to_file2(const char* filename, float data[], int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error: Unable to open file %s for writing.\n", filename);
        return;
    }

    for (int i = 0; i < length; i++) {
        int fixed_point_value = FX_convert(data[i]);
        // Ensure 16-bit representation of the address and data
        int a = i/40; // Sửa từ 20 thành 40 (số lượng PE mới)
        int address = (i + a*24) & 0xFFFF; // Sửa từ 12 thành 24 (64 - 40)
        // printf("address = %d\n",address);
        int data_16bit = fixed_point_value & 0xFFFF; // Mask to 16-bit data
        
        fprintf(file, "%04x_%04x\n", address, data_16bit);
    }

    fclose(file);
}

// Hàm in ra file chỉ chứa Data 16-bit (Giống hệt format Testbench Vivado)
void write_vivado_golden(const char* filename, float data[], int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) return;
    for (int i = 0; i < length; i++) {
        int fixed_point_value = FX_convert(data[i]);
        fprintf(file, "%04x\n", fixed_point_value & 0xFFFF);
    }
    fclose(file);
}

// ========================= DUAL_PE DEBUG/GOLDEN DUMP HELPERS =========================
// These helpers do not change calculation or CRAM/WRAM/BRAM generation.
// They only dump golden outputs in formats convenient for Vivado/Core readback debug.
FILE *golden_manifest_file = fopen("golden_manifest.csv", "w");
FILE *golden_extra_manifest_file = fopen("golden_extra_manifest.csv", "w");

void write_float_plain(const char* filename, const float* data, int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error: Unable to open file %s for writing.\n", filename);
        return;
    }
    for (int i = 0; i < length; i++) {
        fprintf(file, "%.6f\n", data[i]);
    }
    fclose(file);
}

void write_hex_plain(const char* filename, const float* data, int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error: Unable to open file %s for writing.\n", filename);
        return;
    }
    for (int i = 0; i < length; i++) {
        int fixed_point_value = FX_convert(data[i]);
        fprintf(file, "%04x\n", fixed_point_value & 0xFFFF);
    }
    fclose(file);
}

// addr40 format matches 40 PE logical mapping: local_addr = i/40, pe_idx = i%40,
// physical/readback offset = (local_addr << 6) | pe_idx.
void write_addr40_plain(const char* filename, const float* data, int length) {
    FILE *file = fopen(filename, "w");
    if (file == NULL) {
        printf("Error: Unable to open file %s for writing.\n", filename);
        return;
    }
    for (int i = 0; i < length; i++) {
        int fixed_point_value = FX_convert(data[i]);
        int local_addr = i / 40;
        int pe_idx = i % 40;
        int address = (local_addr << 6) | pe_idx;
        fprintf(file, "%04x_%04x\n", address & 0xFFFF, fixed_point_value & 0xFFFF);
    }
    fclose(file);
}

void write_golden_manifest_header_once() {
    static int done = 0;
    if (!done && golden_manifest_file != NULL) {
        fprintf(golden_manifest_file,
                "ctx,function,cram_hex,length,pad,n,y,k,j,alu_cfg,stride,s_ldm,d_ldm,sa_ldm,float_file,hex_file,addr40_file,pea0_even_float,pea1_odd_float\n");
        done = 1;
    }
}

void write_golden_extra_manifest_header_once() {
    static int done = 0;
    if (!done && golden_extra_manifest_file != NULL) {
        fprintf(golden_extra_manifest_file,
                "ctx,function,tag,length,float_file,hex_file,addr40_file\n");
        done = 1;
    }
}

void dump_dual_pea_split_ctx(int ctx,
                            const char* function_name,
                            const float* data,
                            int length,
                            int n_ctx,
                            int alu_cfg,
                            char* pea0_float_file,
                            int pea0_float_file_len,
                            char* pea1_float_file,
                            int pea1_float_file_len) {
    pea0_float_file[0] = '\0';
    pea1_float_file[0] = '\0';

    // Only convolution/MAC contexts use Dual_PE pair execution.
    // In this project, alu_cfg 1 and 5 are MAC/MAC+ReLU style contexts.
    if (!(alu_cfg == 1 || alu_cfg == 5)) return;

    int pair_count = n_ctx + 1;
    int channel_count = pair_count * 2;
    if (pair_count <= 0 || length <= 0 || (length % channel_count) != 0) return;

    int y_len = length / channel_count;
    int split_len = pair_count * y_len;
    float* pea0_even = new float[split_len];
    float* pea1_odd  = new float[split_len];

    for (int p = 0; p < pair_count; p++) {
        for (int y = 0; y < y_len; y++) {
            pea0_even[p * y_len + y] = data[(2 * p) * y_len + y];
            pea1_odd [p * y_len + y] = data[(2 * p + 1) * y_len + y];
        }
    }

    char pea0_hex_file[180];
    char pea1_hex_file[180];
    char pea0_addr40_file[180];
    char pea1_addr40_file[180];

    snprintf(pea0_float_file, pea0_float_file_len, "Golden_ctx%02d_%s_PEA0_even_float.txt", ctx, function_name);
    snprintf(pea1_float_file, pea1_float_file_len, "Golden_ctx%02d_%s_PEA1_odd_float.txt", ctx, function_name);
    snprintf(pea0_hex_file, sizeof(pea0_hex_file), "Golden_ctx%02d_%s_PEA0_even_hex.txt", ctx, function_name);
    snprintf(pea1_hex_file, sizeof(pea1_hex_file), "Golden_ctx%02d_%s_PEA1_odd_hex.txt", ctx, function_name);
    snprintf(pea0_addr40_file, sizeof(pea0_addr40_file), "Golden_ctx%02d_%s_PEA0_even_addr40.txt", ctx, function_name);
    snprintf(pea1_addr40_file, sizeof(pea1_addr40_file), "Golden_ctx%02d_%s_PEA1_odd_addr40.txt", ctx, function_name);

    write_float_plain(pea0_float_file, pea0_even, split_len);
    write_float_plain(pea1_float_file, pea1_odd, split_len);
    write_hex_plain(pea0_hex_file, pea0_even, split_len);
    write_hex_plain(pea1_hex_file, pea1_odd, split_len);
    write_addr40_plain(pea0_addr40_file, pea0_even, split_len);
    write_addr40_plain(pea1_addr40_file, pea1_odd, split_len);

    delete[] pea0_even;
    delete[] pea1_odd;
}

void dump_golden_ctx(const char* function_name,
                     const float* data,
                     int length,
                     uint32_t cram_word,
                     int pad,
                     int n,
                     int y,
                     int k,
                     int j,
                     int alu_cfg,
                     int stride,
                     int s_ldm,
                     int d_ldm,
                     int sa_ldm) {
    int ctx = ctx_addr;
    char float_file[160];
    char hex_file[160];
    char addr40_file[160];
    char pea0_float_file[180];
    char pea1_float_file[180];

    snprintf(float_file, sizeof(float_file), "Golden_ctx%02d_%s_float.txt", ctx, function_name);
    snprintf(hex_file, sizeof(hex_file), "Golden_ctx%02d_%s_hex.txt", ctx, function_name);
    snprintf(addr40_file, sizeof(addr40_file), "Golden_ctx%02d_%s_addr40.txt", ctx, function_name);

    write_float_plain(float_file, data, length);
    write_hex_plain(hex_file, data, length);
    write_addr40_plain(addr40_file, data, length);

    dump_dual_pea_split_ctx(ctx, function_name, data, length, n, alu_cfg,
                            pea0_float_file, sizeof(pea0_float_file),
                            pea1_float_file, sizeof(pea1_float_file));

    write_golden_manifest_header_once();
    if (golden_manifest_file != NULL) {
        fprintf(golden_manifest_file,
                "%02d,%s,%08x,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%d,%s,%s,%s,%s,%s\n",
                ctx, function_name, cram_word, length,
                pad, n, y, k, j, alu_cfg, stride, s_ldm, d_ldm, sa_ldm,
                float_file, hex_file, addr40_file, pea0_float_file, pea1_float_file);
        fflush(golden_manifest_file);
    }
}

void dump_golden_extra(const char* function_name,
                       const char* tag,
                       const float* data,
                       int length) {
    int ctx = ctx_addr;
    char float_file[180];
    char hex_file[180];
    char addr40_file[180];

    snprintf(float_file, sizeof(float_file), "Golden_ctx%02d_%s_%s_float.txt", ctx, function_name, tag);
    snprintf(hex_file, sizeof(hex_file), "Golden_ctx%02d_%s_%s_hex.txt", ctx, function_name, tag);
    snprintf(addr40_file, sizeof(addr40_file), "Golden_ctx%02d_%s_%s_addr40.txt", ctx, function_name, tag);

    write_float_plain(float_file, data, length);
    write_hex_plain(hex_file, data, length);
    write_addr40_plain(addr40_file, data, length);

    write_golden_extra_manifest_header_once();
    if (golden_extra_manifest_file != NULL) {
        fprintf(golden_extra_manifest_file,
                "%02d,%s,%s,%d,%s,%s,%s\n",
                ctx, function_name, tag, length, float_file, hex_file, addr40_file);
        fflush(golden_extra_manifest_file);
    }
}

void dump_golden_post(const char* function_name,
                      const float* data,
                      int length) {
    char float_file[160];
    char hex_file[160];
    char addr40_file[160];

    snprintf(float_file, sizeof(float_file), "Golden_post_%s_float.txt", function_name);
    snprintf(hex_file, sizeof(hex_file), "Golden_post_%s_hex.txt", function_name);
    snprintf(addr40_file, sizeof(addr40_file), "Golden_post_%s_addr40.txt", function_name);

    write_float_plain(float_file, data, length);
    write_hex_plain(hex_file, data, length);
    write_addr40_plain(addr40_file, data, length);
}

void dump_golden_extra_parts(const char* function_name,
                             const char* tag,
                             const float* data,
                             int total_length,
                             int part_length) {
    dump_golden_extra(function_name, tag, data, total_length);

    if (part_length <= 0 || total_length % part_length != 0) {
        return;
    }

    int parts = total_length / part_length;
    for (int p = 0; p < parts; p++) {
        char part_tag[160];
        snprintf(part_tag, sizeof(part_tag), "%s_part%d_offset%d", tag, p, p * part_length);
        dump_golden_extra(function_name, part_tag, data + p * part_length, part_length);
    }
}
// ======================= END DUAL_PE DEBUG/GOLDEN DUMP HELPERS =======================


// Helper function to round a value to three decimal places
// ======================= DUAL_PE CRAM OFFSET NOTE =======================
// For branch-concat convolution contexts producing 320 values:
//   physical LDM row length = 40 PE
//   occupied rows = 320 / 40 = 8 rows
// Therefore branch offsets inside the same destination LDM must be:
//   0, 8, 16, 24
// The old 0,16,32,48 pattern is a 20PE-era/incorrect 40PE/Dual_PE spacing
// and leaves holes, causing later Add2D contexts to add wrong/gapped data.
// =======================================================================


float fixedpoint_converter(float value) {
	if(value >= 512){
		printf("Value is larger than 512 = %f\n", value);
		value = value - 512;	
	}
    float scalingFactor = 64.0f; // 2^5
    return round(value * scalingFactor) / scalingFactor; 
}

// Finalize convolution output to match RTL write-back.
// RTL stores quantized fixed-point values. For alu_cfg_ctx == 5,
// the MAC path includes ReLU, so negative values must be clamped to zero
// before dumping Golden_ctxXX_* files and before feeding later software layers.
void finalize_conv_output_for_rtl(float data[], int length, int alu_cfg_ctx) {
    for (int i = 0; i < length; i++) {
        data[i] = fixedpoint_converter(data[i]);
        if (alu_cfg_ctx == 5 && data[i] < 0) {
            data[i] = 0;
        }
    }
}


// ======================= RTL-EXACT GOLDEN MAC HELPERS =======================
// These helpers DO NOT change CRAM/WRAM/BRAM generation.
// They only overwrite Output_Conv before dumping Golden_ctxXX_* so the software
// golden follows the same Q6 MAC arithmetic as RTL ALU/MAC:
//   1) multiply int16 Q6 x int16 Q6
//   2) take product bits [21:6] and add product bit [5] for rounding
//   3) accumulate in signed 16-bit wrap-around
//   4) add bias only at the final MAC step
//   5) apply ReLU only for alu_cfg_ctx == 5
static inline int16_t rtl_wrap_i16(int32_t x) {
    return (int16_t)((uint16_t)x);
}

static inline int16_t rtl_fx_from_float(float x) {
    return FX_convert(x);
}

static inline float rtl_fx_to_float(int16_t x) {
    return ((float)x) / ((float)SCALE_FACTOR);
}

static inline int16_t rtl_mul_q6_i16(int16_t a, int16_t b) {
    int32_t prod = (int32_t)a * (int32_t)b;
    uint32_t prod_bits = (uint32_t)prod;

    // Verilog equivalent:
    //   sum_final_wr = mult_result_rg[21:6] + mult_result_rg[5];
    uint32_t slice_21_6 = (prod_bits >> FRACTIONAL_BITS) & 0xFFFFu;
    uint32_t round_bit  = (prod_bits >> (FRACTIONAL_BITS - 1)) & 0x1u;
    return (int16_t)((uint16_t)(slice_21_6 + round_bit));
}

void rtl_exact_conv1d_q6(float Output_Conv[],
                         int output_len,
                         const float Input_Conv[],
                         int input_len,
                         const float bias[],
                         int bias_len,
                         const float kernel[],
                         int kernel_len,
                         int stride,
                         int kernel_size,
                         int alu_cfg_ctx) {
    if (output_len <= 0 || input_len <= 0 || bias_len <= 0 ||
        kernel_len <= 0 || stride <= 0 || kernel_size <= 0) {
        return;
    }

    int out_channels = bias_len;
    if ((output_len % out_channels) != 0) {
        printf("[RTL_GOLDEN_WARN] output_len %% out_channels != 0\n");
        return;
    }

    int y_len = output_len / out_channels;
    int kj_per_out_channel = kernel_len / out_channels;
    if ((kernel_len % out_channels) != 0 || (kj_per_out_channel % kernel_size) != 0) {
        printf("[RTL_GOLDEN_WARN] bad kernel dimensions: kernel_len=%d out_channels=%d kernel_size=%d\n",
               kernel_len, out_channels, kernel_size);
        return;
    }

    int in_channels = kj_per_out_channel / kernel_size;
    if ((input_len % in_channels) != 0) {
        printf("[RTL_GOLDEN_WARN] input_len %% in_channels != 0\n");
        return;
    }

    int input_y_len = input_len / in_channels;
    int relu_en = (alu_cfg_ctx == 5);

    for (int n = 0; n < out_channels; n++) {
        int16_t bias_fx = rtl_fx_from_float(bias[n]);

        for (int y = 0; y < y_len; y++) {
            int16_t acc = 0;
            int total_mac = in_channels * kernel_size;

            for (int kk = 0; kk < in_channels; kk++) {
                for (int jj = 0; jj < kernel_size; jj++) {
                    int mac_idx = kk * kernel_size + jj;
                    int input_idx = input_y_len * kk + jj + y * stride;
                    int weight_idx = kj_per_out_channel * n + kernel_size * kk + jj;

                    int16_t x_fx = 0;
                    if (input_idx >= 0 && input_idx < input_len) {
                        x_fx = rtl_fx_from_float(Input_Conv[input_idx]);
                    }

                    int16_t w_fx = rtl_fx_from_float(kernel[weight_idx]);
                    int16_t mul_fx = rtl_mul_q6_i16(x_fx, w_fx);

                    if (mac_idx == total_mac - 1) {
                        int16_t out_fx = rtl_wrap_i16((int32_t)mul_fx + (int32_t)acc + (int32_t)bias_fx);
                        if (relu_en && out_fx < 0) {
                            out_fx = 0;
                        }
                        Output_Conv[y_len * n + y] = rtl_fx_to_float(out_fx);
                    } else {
                        acc = rtl_wrap_i16((int32_t)mul_fx + (int32_t)acc);
                    }
                }
            }
        }
    }
}
// ===================== END RTL-EXACT GOLDEN MAC HELPERS =====================



void Padding_Conv1D_0(float input_Pad_Conv[320], float output_Pad_Conv[324]){
	write_to_file2("LDM_File.txt", input_Pad_Conv, 320);
	loop_for_3_channel_pad_0:
	for (int c = 0; c < 1; c++){
		loop_for_channel_pad_0:
		for (int n = 0; n < 324; n++){
			if (n < 2 || n >= 322) output_Pad_Conv[324 * c + n]=0; else output_Pad_Conv[324 * c + n] = input_Pad_Conv[320 * c + n - 2];
		}
	}
}
void Conv1D_0(float Input_Conv[324],float Output_Conv[1280], float bias[8], float kernel[56]){
	loop_for_channel_0:
	int stride = 2;
	int n, y, k, j;

	for (int i = 0; i < 324; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
		// printf("bias[%d] before: %f\n",i,bias[i]);
        bias[i] = fixedpoint_converter(bias[i]);
		// printf("bias[%d] after: %f\n",i,bias[i]);
    }
	for (int i = 0; i < 56; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	
	for ( n = 0; n < 8; n++){
		loop_for_ap_0:
		for ( y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_0:
			for ( k = 0; k < 1; k++){
				loop_for_fa_0:
				for ( j = 0; j < 7; j++){
					s=s+(kernel[1*7*n+7*k+j])*(Input_Conv[324*k+j+y*stride]);
					s=fixedpoint_converter(s);
					// if((((324*k+j+y*stride)%324)>=2&&((324*k+j+y*stride)%324)<322))
						// printf("PE = %d, W_addr = %d, from PE = %d, Read LDM_addr = %d (%d), Data = %f, kernel = %f, s = %f\n",y%20, 1*7*n+7*k+j,(324*k+j+y*stride-2*(k+1))%20, (324*k+j+y*stride-2*(k+1))/20,(324*k+j+y*stride-2*(k+1)),Input_Conv[324*k+j+y*stride], kernel[1*7*n+7*k+j], fixedpoint_converter(s));
					// else 
						// printf("PE = %d, W_addr = %d, from PE = %d, Read Pad_addr = %d, Data = %f, kernel = %f, s = %f\n",y%20,1*7*n+7*k+j,(324*k+j+y*stride-2*(k+1)+20)%20,324*k+j+y*stride,Input_Conv[324*k+j+y*stride], kernel[1*7*n+7*k+j], s);
					}
					
						
					
			}
			Output_Conv[160*n+y]=s+bias[n];
			// printf("PE = %d, bias_addr = %d, Store LDM_addr = %d, s = %f, Output_Conv[%d] = %f\n\n\n",(160*n+y)%20,n,(160*n+y)/20, s, 160*n+y, fixedpoint_converter(Output_Conv[160*n+y]));
			
		}
	}

	for (int i = 0; i < 1280; i++) {
		Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
		if (Output_Conv[i] < 0) Output_Conv[i] = 0;   // match RTL ReLU

    }
	
    // write_to_file("Output_Conv.txt", Output_Conv, 1280);
	write_vivado_golden("Golden_Output_Layer1_relu.txt", Output_Conv, 1280);	

    write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 56, 8);
	int pad_ctx = 2, n_ctx = 3, y_ctx = 3, k_ctx = 0, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 1,s_ldm_ctx = 0, d_ldm_ctx = 3, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 1280, Input_Conv, 324, bias, 8, kernel, 56, stride, j_ctx + 1, alu_cfg_ctx);

	// RTL exact rewrite for legacy layer1 golden file.
	write_vivado_golden("Golden_Output_Layer1_relu.txt", Output_Conv, 1280);

	finalize_conv_output_for_rtl(Output_Conv, 1280, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
	// fclose(weight_file);
	// fclose(bias_file);
	// fclose(context_file);
}
 void Activation0(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Conv1D_1(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_1:
	int stride = 1;
	int n, y, k, j;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
	
	// write_to_file2("LDM_File.txt", Input_Conv, 1280);
	
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 16; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (n = 0; n < 2; n++){
		loop_for_ap_1:
		for (y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_1:
			for (k = 0; k < 8; k++){
				loop_for_fa_1:
				for (j = 0; j < 1; j++){
					s=s+(kernel[8*1*n+1*k+j])*(Input_Conv[160*k+j+y*stride]);
					// printf("kernel[8*1*n+1*k+j] = %d, Input_Conv[160*k+j+y*stride] = %d\n",8*1*n+1*k+j,160*k+j+y*stride);
					// printf("AT PE = %d, kernel[1*7*n+7*k+j] = %d, PE = %d, Read LDM address = %d\n",y%20, 1*7*n+7*k+j,(160*k+j+y*stride)%20, (160*k+j+y*stride)/20);
					
					}
			}
			Output_Conv[160*n+y]=s+bias[n];
			// printf("Output_Conv[160*n+y] = %d, n = %d\n",160*n+y,n);
			// printf("AT PE = %d, bias = %d, Store LDM address = %d\n\n\n",(160*n+y)%20,n,(160*n+y)/20);
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	// write_to_file("Output_Conv.txt", Output_Conv, 320);
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 16, 2);
	int pad_ctx = 0, n_ctx = 0, y_ctx = 3, k_ctx = 7, j_ctx = 0, alu_cfg_ctx = 1, stride_ctx = 0, s_ldm_ctx = 3, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 2, kernel, 16, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Conv1D_2(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_2:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 16; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_2:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_2:
			for (int k = 0; k < 8; k++){
				loop_for_fa_2:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[8*1*n+1*k+j])*(Input_Conv[160*k+j+y*stride]);
					
					 // printf("PE = %d, W_addr = %d, from PE = %d, Read LDM_addr = %d (%d), Data = %f, kernel = %f, s = %f\n",y%20, 8*1*n+1*k+j,(160*k+j+y*stride)%20, (160*k+j+y*stride)/20,(160*k+j+y*stride),Input_Conv[160*k+j+y*stride], kernel[8*1*n+1*k+j], fixedpoint_converter(s));
					}
			}
			Output_Conv[160*n+y]=s+bias[n];
			// printf("PE = %d, bias_addr = %d, bias = %f, Store LDM_addr = %d, s = %f, Output_Conv[%d] = %f\n\n\n",(160*n+y)%20,n,bias[n],(160*n+y)/20, s, 160*n+y, fixedpoint_converter(Output_Conv[160*n+y]));
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	// write_to_file("Output_Conv.txt", Output_Conv, 320);
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 16, 2);
	int pad_ctx = 0, n_ctx = 0, y_ctx = 3, k_ctx = 7, j_ctx = 0, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 2, kernel, 16, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_3(float input_Pad_Conv[320], float output_Pad_Conv[324]){
	loop_for_3_channel_pad_3:
	for (int c = 0; c < 2; c++){
		loop_for_channel_pad_3:
		for (int n = 0; n < 162; n++){
			if (n < 1 || n >= 161) output_Pad_Conv[162 * c + n]=0; else output_Pad_Conv[162 * c + n] = input_Pad_Conv[160 * c + n - 1];
		}
	}
}
void Conv1D_3(float Input_Conv[324],float Output_Conv[320], float bias[2], float kernel[12]){
	loop_for_channel_3:
	int stride = 1;
	
	for (int i = 0; i < 324; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 12; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_3:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_3:
			for (int k = 0; k < 2; k++){
				loop_for_fa_3:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[2*3*n+3*k+j])*(Input_Conv[162*k+j+y*stride]);
					// if((((162*k+j+y*stride)%162)>=2&&((162*k+j+y*stride)%162)<162))
						// printf("PE = %d, W_addr = %d, from PE = %d, Read LDM_addr = %d (%d)\n",y%20, 162*k+j+y*stride,(162*k+j+y*stride-2*(k+1)-2*k)%20, (162*k+j+y*stride-2*(k+1)-2*k)/20,(162*k+j+y*stride-2*(k+1)-2*k));
					// else 
						// printf("PE = %d, W_addr = %d, from PE = %d, Read Pad_addr = %d\n",y%20,162*k+j+y*stride,(162*k+j+y*stride-2*(k+1)-2*k+20)%20,162*k+j+y*stride);
					}
			}
			Output_Conv[160*n+y]=s+bias[n];
			// printf("Output_Conv[160*n+y] = %d, n = %d\n",160*n+y,n);
			// printf("AT PE = %d, bias = %d, Store LDM address = %d\n\n\n",(160*n+y)%20,n,(160*n+y)/20);
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 12, 2);
	int pad_ctx = 1, n_ctx = 0, y_ctx = 3, k_ctx = 1, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 8;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 324, bias, 2, kernel, 12, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_4(float input_Pad_Conv[320], float output_Pad_Conv[328]){
	loop_for_3_channel_pad_4:
	for (int c = 0; c < 2; c++){
		loop_for_channel_pad_4:
		for (int n = 0; n < 164; n++){
			if (n < 2 || n >= 162) output_Pad_Conv[164 * c + n]=0; else output_Pad_Conv[164 * c + n] = input_Pad_Conv[160 * c + n - 2];
		}
	}
}
void Conv1D_4(float Input_Conv[328],float Output_Conv[320], float bias[2], float kernel[20]){
	loop_for_channel_4:
	int stride = 1;
	
	for (int i = 0; i < 328; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 20; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_4:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_4:
			for (int k = 0; k < 2; k++){
				loop_for_fa_4:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[2*5*n+5*k+j])*(Input_Conv[164*k+j+y*stride]);
					// if((((164*k+j+y*stride)%164)>=2&&((164*k+j+y*stride)%164)<162))
						// printf("PE = %d, W_addr = %d, from PE = %d, Read LDM_addr = %d (%d)\n",y%20, 2*5*n+5*k+j,(164*k+j+y*stride-2*(k+1))%20, (164*k+j+y*stride-2*(k+1))/20,(164*k+j+y*stride-2*(k+1)));
					// else 
						// printf("PE = %d, W_addr = %d, from PE = %d, Read Pad_addr = %d\n",y%20,2*5*n+5*k+j,(164*k+j+y*stride-2*(k+1)+20)%20, 164*k+j+y*stride);
					}
			}
			Output_Conv[160*n+y]=s+bias[n];
			// printf("PE = %d, bias_addr = %d, Store LDM_addr = %d\n\n\n",(160*n+y)%20,n,(160*n+y)/20);
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 20, 2);
	int pad_ctx = 2, n_ctx = 0, y_ctx = 3, k_ctx = 1, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 16;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 328, bias, 2, kernel, 20, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_5(float input_Pad_Conv[320], float output_Pad_Conv[332]){
	// write_to_file2("LDM_File.txt", input_Pad_Conv, 320);
	
	loop_for_3_channel_pad_5:
	for (int c = 0; c < 2; c++){
		loop_for_channel_pad_5:
		for (int n = 0; n < 166; n++){
			if (n < 3 || n >= 163) output_Pad_Conv[166 * c + n]=0; else output_Pad_Conv[166 * c + n] = input_Pad_Conv[160 * c + n - 3];
		}
	}
}
void Conv1D_5(float Input_Conv[332],float Output_Conv[320], float bias[2], float kernel[28]){
	loop_for_channel_5:
	int stride = 1;
	
	for (int i = 0; i < 332; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 28; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_5:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_5:
			for (int k = 0; k < 2; k++){
				loop_for_fa_5:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[2*7*n+7*k+j])*(Input_Conv[166*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 28, 2);
	int pad_ctx = 3, n_ctx = 0, y_ctx = 3, k_ctx = 1, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 24;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 332, bias, 2, kernel, 28, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	 
}
 void Activation1(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Conv1D_6(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_6:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 16; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_6:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_6:
			for (int k = 0; k < 8; k++){
				loop_for_fa_6:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[8*1*n+1*k+j])*(Input_Conv[160*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 16, 2);
	int pad_ctx = 0, n_ctx = 0, y_ctx = 3, k_ctx = 7, j_ctx = 0, alu_cfg_ctx = 1, stride_ctx = 0, s_ldm_ctx = 1, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 2, kernel, 16, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Conv1D_7(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_7:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 16; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_7:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_7:
			for (int k = 0; k < 8; k++){
				loop_for_fa_7:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[8*1*n+1*k+j])*(Input_Conv[160*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 16, 2);
	int pad_ctx = 0, n_ctx = 0, y_ctx = 3, k_ctx = 7, j_ctx = 0, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 2, kernel, 16, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Padding_Conv1D_8(float input_Pad_Conv[320], float output_Pad_Conv[324]){
	
	// write_to_file2("LDM_File.txt", input_Pad_Conv, 320);
	loop_for_3_channel_pad_8:
	for (int c = 0; c < 2; c++){
		loop_for_channel_pad_8:
		for (int n = 0; n < 162; n++){
			if (n < 1 || n >= 161) output_Pad_Conv[162 * c + n]=0; else output_Pad_Conv[162 * c + n] = input_Pad_Conv[160 * c + n - 1];
		}
	}
}
void Conv1D_8(float Input_Conv[324],float Output_Conv[320], float bias[2], float kernel[12]){
	loop_for_channel_8:
	int stride = 1;
	
	for (int i = 0; i < 324; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 12; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_8:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_8:
			for (int k = 0; k < 2; k++){
				loop_for_fa_8:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[2*3*n+3*k+j])*(Input_Conv[162*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 12, 2);
	int pad_ctx = 1, n_ctx = 0, y_ctx = 3, k_ctx = 1, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 8;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 324, bias, 2, kernel, 12, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_9(float input_Pad_Conv[320], float output_Pad_Conv[328]){
	loop_for_3_channel_pad_9:
	for (int c = 0; c < 2; c++){
		loop_for_channel_pad_9:
		for (int n = 0; n < 164; n++){
			if (n < 2 || n >= 162) output_Pad_Conv[164 * c + n]=0; else output_Pad_Conv[164 * c + n] = input_Pad_Conv[160 * c + n - 2];
		}
	}
}
void Conv1D_9(float Input_Conv[328],float Output_Conv[320], float bias[2], float kernel[20]){
	loop_for_channel_9:
	int stride = 1;
	
	for (int i = 0; i < 328; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 20; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_9:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_9:
			for (int k = 0; k < 2; k++){
				loop_for_fa_9:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[2*5*n+5*k+j])*(Input_Conv[164*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 20, 2);
	int pad_ctx = 2, n_ctx = 0, y_ctx = 3, k_ctx = 1, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 16;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 328, bias, 2, kernel, 20, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_10(float input_Pad_Conv[320], float output_Pad_Conv[332]){
	loop_for_3_channel_pad_10:
	for (int c = 0; c < 2; c++){
		loop_for_channel_pad_10:
		for (int n = 0; n < 166; n++){
			if (n < 3 || n >= 163) output_Pad_Conv[166 * c + n]=0; else output_Pad_Conv[166 * c + n] = input_Pad_Conv[160 * c + n - 3];
		}
	}
}
void Conv1D_10(float Input_Conv[332],float Output_Conv[320], float bias[2], float kernel[28]){
	loop_for_channel_10:
	int stride = 1;
	
	for (int i = 0; i < 332; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 2; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 28; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 2; n++){
		loop_for_ap_10:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_10:
			for (int k = 0; k < 2; k++){
				loop_for_fa_10:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[2*7*n+7*k+j])*(Input_Conv[166*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 2);
    write_weight_to_file(kernel, 28, 2);
	int pad_ctx = 3, n_ctx = 0, y_ctx = 3, k_ctx = 1, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 24;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 332, bias, 2, kernel, 28, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
 void Activation2(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
 void Add2D_0(float input_0[1280], float input_1[1280], float output[1280]) {
	int size =1280;
	dump_golden_extra_parts(__func__, "input0_relu2_before_add", input_0, 1280, 320);
	dump_golden_extra_parts(__func__, "input1_residual_before_add", input_1, 1280, 320);
	for (int i = 0; i < size; i++){
		output[i] = input_0[i] + input_1[i];
	}
	
	// write_to_file("Output_Conv.txt", output, 1280);
		int pad_ctx = 0, n_ctx = 7, y_ctx = 3, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 2, stride_ctx = 0, s_ldm_ctx = 2, d_ldm_ctx = 1, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);

	dump_golden_extra_parts(__func__, "output_after_add", output, 1280, 320);
}
void Padding_Conv1D_11(float input_Pad_Conv[1280], float output_Pad_Conv[1296]){
	// write_to_file2("LDM_File.txt", input_Pad_Conv, 1280);
	loop_for_3_channel_pad_11:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_11:
		for (int n = 0; n < 162; n++){
			if (n < 1 || n >= 161) output_Pad_Conv[162 * c + n]=0; else output_Pad_Conv[162 * c + n] = input_Pad_Conv[160 * c + n - 1];
		}
	}
}
void Conv1D_11(float Input_Conv[1296],float Output_Conv[1280], float bias[16], float kernel[640]){
	loop_for_channel_11:
	int stride = 2;
	
	for (int i = 0; i < 1296; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 16; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 640; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 16; n++){
		loop_for_ap_11:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_11:
			for (int k = 0; k < 8; k++){
				loop_for_fa_11:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[8*5*n+5*k+j])*(Input_Conv[162*k+j+y*stride]);
					s=fixedpoint_converter(s);
					
					// if((y%20) == 19){
						// if((((162*k+j+y*stride)%162)>=1&&((162*k+j+y*stride)%162)<161))
							// printf("PE = %d, W_addr = %d, from PE = %d, Read LDM_addr = %d (%d), Data = %f, kernel = %f, s = %f\n",y%20, 8*5*n+5*k+j,(162*k+j+y*stride-(1+2*k))%20, (162*k+j+y*stride-(1+2*k))/20,(162*k+j+y*stride-(1+2*k)),Input_Conv[162*k+j+y*stride], kernel[8*5*n+5*k+j], fixedpoint_converter(s));
						// else 
							// printf("PE = %d, W_addr = %d, from PE = %d, Read Pad_addr = %d, Data = %f, kernel = %f, s = %f\n",y%20,8*5*n+5*k+j,(162*k+j+y*stride-(1+2*k)+20)%20,162*k+j+y*stride,Input_Conv[162*k+j+y*stride], kernel[8*5*n+5*k+j], s);
					// }
				}
			}
			Output_Conv[80*n+y]=s+bias[n];
			// if((y%20) == 19)
				// printf("PE = %d, bias_addr = %d, Store LDM_addr = %d, s = %f, Output_Conv[%d] = %f\n\n\n",(80*n+y)%20,n,(80*n+y)/20, s, 80*n+y, fixedpoint_converter(Output_Conv[80*n+y]));
		}
	}
	
	// for (int n = 15; n>=0; n--){
		// for (int y = 79; y >= 0; y--){
			// if((80*n+y)%20 == 18)
						// printf("PE = %d, Output_Conv[%d] = %f\n",(80*n+y)%20,(80*n+y)/20, fixedpoint_converter(Output_Conv[(80*n+y)]));
		// }
	// }

    // write_to_file("Output_Conv.txt", Output_Conv, 1280);
    // write_to_file("BRAM_File.txt", bias, 16);
    // write_to_file("WRAM_File.txt", kernel, 640);

    // int pad_ctx = 1, n_ctx = 7, y_ctx = 80, k_ctx = 7, j_ctx = 4, alu_cfg_ctx = 1, stride_ctx = 1, resCon_ctx = 0;

    // // Call the function to concatenate inputs into a 28-bit output
    // uint32_t result = concatenate_to_29bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, resCon_ctx);
    
    // // Pass the address of result to write_to_file2
    // write_to_file3("CRAM_File.txt", &result, 1);
	write_bias_to_file(bias, 16);
    write_weight_to_file(kernel, 640, 16);
	int pad_ctx = 1, n_ctx = 7, y_ctx = 1, k_ctx = 7, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 1,s_ldm_ctx = 1, d_ldm_ctx = 3, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 1280, Input_Conv, 1296, bias, 16, kernel, 640, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 1280, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
	for (int i = 0; i < 1280; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
}
 void Activation3(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Conv1D_12(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_12:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 64; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_12:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_12:
			for (int k = 0; k < 16; k++){
				loop_for_fa_12:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[16*1*n+1*k+j])*(Input_Conv[80*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	// write_to_file("Output_Conv.txt", Output_Conv, 320);
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 64, 4);
	int pad_ctx = 0, n_ctx = 1, y_ctx = 1, k_ctx = 15, j_ctx = 0, alu_cfg_ctx = 1, stride_ctx = 0, s_ldm_ctx = 3, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 4, kernel, 64, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Conv1D_13(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_13:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 64; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_13:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_13:
			for (int k = 0; k < 16; k++){
				loop_for_fa_13:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[16*1*n+1*k+j])*(Input_Conv[80*k+j+y*stride]);
						// if((y%20) == 0){
							// printf("PE = %d, W_addr = %d, from PE = %d, Read LDM_addr = %d (%d), Data = %f, kernel = %f, s = %f\n",y%20, 16*1*n+1*k+j,(80*k+j+y*stride)%20, (80*k+j+y*stride)/20,(80*k+j+y*stride),Input_Conv[80*k+j+y*stride], kernel[16*1*n+1*k+j], fixedpoint_converter(s));
						// }
					
					}
			}
			Output_Conv[80*n+y]=s+bias[n];
			
			// if((y%20) == 0)
				// printf("PE = %d, bias_addr = %d, Store LDM_addr = %d, s = %f, Output_Conv[%d] = %f\n\n\n",(80*n+y)%20,n,(80*n+y)/20, s, 80*n+y, fixedpoint_converter(Output_Conv[80*n+y]));
		}
	}
	
	for (int i = 0; i < 320; i++) {
		if(Output_Conv[i]>0)
			Output_Conv[i] = Output_Conv[i];
		else 
			Output_Conv[i] = 0;
    }
	
	// write_to_file("Output_Conv.txt", Output_Conv, 320);
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 64, 4);
	int pad_ctx = 0, n_ctx = 1, y_ctx = 1, k_ctx = 15, j_ctx = 0, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 4, kernel, 64, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
}
void Padding_Conv1D_14(float input_Pad_Conv[320], float output_Pad_Conv[328]){
	loop_for_3_channel_pad_14:
	for (int c = 0; c < 4; c++){
		loop_for_channel_pad_14:
		for (int n = 0; n < 82; n++){
			if (n < 1 || n >= 81) output_Pad_Conv[82 * c + n]=0; else output_Pad_Conv[82 * c + n] = input_Pad_Conv[80 * c + n - 1];
		}
	}
}
void Conv1D_14(float Input_Conv[328],float Output_Conv[320], float bias[4], float kernel[48]){
	loop_for_channel_14:
	int stride = 1;
	
	for (int i = 0; i < 328; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 48; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_14:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_14:
			for (int k = 0; k < 4; k++){
				loop_for_fa_14:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[4*3*n+3*k+j])*(Input_Conv[82*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 48, 4);
	int pad_ctx = 1, n_ctx = 1, y_ctx = 1, k_ctx = 3, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 8;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 328, bias, 4, kernel, 48, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_15(float input_Pad_Conv[320], float output_Pad_Conv[336]){
	loop_for_3_channel_pad_15:
	for (int c = 0; c < 4; c++){
		loop_for_channel_pad_15:
		for (int n = 0; n < 84; n++){
			if (n < 2 || n >= 82) output_Pad_Conv[84 * c + n]=0; else output_Pad_Conv[84 * c + n] = input_Pad_Conv[80 * c + n - 2];
		}
	}
}
void Conv1D_15(float Input_Conv[336],float Output_Conv[320], float bias[4], float kernel[80]){
	loop_for_channel_15:
	int stride = 1;
	
	for (int i = 0; i < 336; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 80; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_15:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_15:
			for (int k = 0; k < 4; k++){
				loop_for_fa_15:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[4*5*n+5*k+j])*(Input_Conv[84*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 80, 4);
	int pad_ctx = 2, n_ctx = 1, y_ctx = 1, k_ctx = 3, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 16;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 336, bias, 4, kernel, 80, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
}
void Padding_Conv1D_16(float input_Pad_Conv[320], float output_Pad_Conv[344]){
	loop_for_3_channel_pad_16:
	for (int c = 0; c < 4; c++){
		loop_for_channel_pad_16:
		for (int n = 0; n < 86; n++){
			if (n < 3 || n >= 83) output_Pad_Conv[86 * c + n]=0; else output_Pad_Conv[86 * c + n] = input_Pad_Conv[80 * c + n - 3];
		}
	}
}
void Conv1D_16(float Input_Conv[344],float Output_Conv[320], float bias[4], float kernel[112]){
	loop_for_channel_16:
	int stride = 1;
	
	for (int i = 0; i < 344; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 112; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_16:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_16:
			for (int k = 0; k < 4; k++){
				loop_for_fa_16:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[4*7*n+7*k+j])*(Input_Conv[86*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 112, 4);
	int pad_ctx = 3, n_ctx = 1, y_ctx = 1, k_ctx = 3, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 24;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 344, bias, 4, kernel, 112, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
 void Activation4(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Conv1D_17(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_17:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 64; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_17:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_17:
			for (int k = 0; k < 16; k++){
				loop_for_fa_17:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[16*1*n+1*k+j])*(Input_Conv[80*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 64, 4);
	int pad_ctx = 0, n_ctx = 1, y_ctx = 1, k_ctx = 15, j_ctx = 0, alu_cfg_ctx = 1, stride_ctx = 0, s_ldm_ctx = 2, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 4, kernel, 64, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Conv1D_18(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_18:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 64; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_18:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_18:
			for (int k = 0; k < 16; k++){
				loop_for_fa_18:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[16*1*n+1*k+j])*(Input_Conv[80*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 64, 4);
	int pad_ctx = 0, n_ctx = 1, y_ctx = 1, k_ctx = 15, j_ctx = 0, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 4, kernel, 64, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
}
void Padding_Conv1D_19(float input_Pad_Conv[320], float output_Pad_Conv[328]){
	loop_for_3_channel_pad_19:
	for (int c = 0; c < 4; c++){
		loop_for_channel_pad_19:
		for (int n = 0; n < 82; n++){
			if (n < 1 || n >= 81) output_Pad_Conv[82 * c + n]=0; else output_Pad_Conv[82 * c + n] = input_Pad_Conv[80 * c + n - 1];
		}
	}
}
void Conv1D_19(float Input_Conv[328],float Output_Conv[320], float bias[4], float kernel[48]){
	loop_for_channel_19:
	int stride = 1;
	
	for (int i = 0; i < 328; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 48; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_19:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_19:
			for (int k = 0; k < 4; k++){
				loop_for_fa_19:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[4*3*n+3*k+j])*(Input_Conv[82*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 48, 4);
	int pad_ctx = 1, n_ctx = 1, y_ctx = 1, k_ctx = 3, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 8;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 328, bias, 4, kernel, 48, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_20(float input_Pad_Conv[320], float output_Pad_Conv[336]){
	loop_for_3_channel_pad_20:
	for (int c = 0; c < 4; c++){
		loop_for_channel_pad_20:
		for (int n = 0; n < 84; n++){
			if (n < 2 || n >= 82) output_Pad_Conv[84 * c + n]=0; else output_Pad_Conv[84 * c + n] = input_Pad_Conv[80 * c + n - 2];
		}
	}
}
void Conv1D_20(float Input_Conv[336],float Output_Conv[320], float bias[4], float kernel[80]){
	loop_for_channel_20:
	int stride = 1;
	
	for (int i = 0; i < 336; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 80; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_20:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_20:
			for (int k = 0; k < 4; k++){
				loop_for_fa_20:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[4*5*n+5*k+j])*(Input_Conv[84*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 80, 4);
	int pad_ctx = 2, n_ctx = 1, y_ctx = 1, k_ctx = 3, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 16;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 336, bias, 4, kernel, 80, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_21(float input_Pad_Conv[320], float output_Pad_Conv[344]){
	loop_for_3_channel_pad_21:
	for (int c = 0; c < 4; c++){
		loop_for_channel_pad_21:
		for (int n = 0; n < 86; n++){
			if (n < 3 || n >= 83) output_Pad_Conv[86 * c + n]=0; else output_Pad_Conv[86 * c + n] = input_Pad_Conv[80 * c + n - 3];
		}
	}
}
void Conv1D_21(float Input_Conv[344],float Output_Conv[320], float bias[4], float kernel[112]){
	loop_for_channel_21:
	int stride = 1;
	
	for (int i = 0; i < 344; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 4; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 112; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 4; n++){
		loop_for_ap_21:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_21:
			for (int k = 0; k < 4; k++){
				loop_for_fa_21:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[4*7*n+7*k+j])*(Input_Conv[86*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 4);
    write_weight_to_file(kernel, 112, 4);
	int pad_ctx = 3, n_ctx = 1, y_ctx = 1, k_ctx = 3, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 24;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 344, bias, 4, kernel, 112, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
 void Activation5(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
 void Add2D_1(float input_0[1280], float input_1[1280], float output[1280]) {
	int size =1280;
	dump_golden_extra_parts(__func__, "input0_relu4_before_add", input_0, 1280, 320);
	dump_golden_extra_parts(__func__, "input1_residual_before_add", input_1, 1280, 320);
	for (int i = 0; i < size; i++){
		output[i] = input_0[i] + input_1[i];
	}
	
	// write_to_file("Output_Conv.txt", output, 1280);
	// write_to_file("Output_Conv.txt", output, 1280);
	int pad_ctx = 0, n_ctx = 7, y_ctx = 3, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 2, stride_ctx = 0, s_ldm_ctx = 1, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);

	dump_golden_extra_parts(__func__, "output_after_add", output, 1280, 320);
}
void Padding_Conv1D_22(float input_Pad_Conv[1280], float output_Pad_Conv[1280]){
	loop_for_3_channel_pad_22:
	for (int c = 0; c < 16; c++){
		loop_for_channel_pad_22:
		for (int n = 0; n < 80; n++){
			if (n < 0 || n >= 80) output_Pad_Conv[80 * c + n]=0; else output_Pad_Conv[80 * c + n] = input_Pad_Conv[80 * c + n - 0];
		}
	}
}
void Conv1D_22(float Input_Conv[1280],float Output_Conv[1280], float bias[32], float kernel[1536]){
	loop_for_channel_22:
	int stride = 2;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 32; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 1536; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 32; n++){
		loop_for_ap_22:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_22:
			for (int k = 0; k < 16; k++){
				loop_for_fa_22:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[16*3*n+3*k+j])*(Input_Conv[80*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 1280; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	// write_to_file("Output_Conv.txt", Output_Conv, 1280);
	write_bias_to_file(bias, 32);
    write_weight_to_file(kernel, 1536, 32);
	int pad_ctx = 0, n_ctx = 15, y_ctx = 0, k_ctx = 15, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 1,s_ldm_ctx = 0, d_ldm_ctx = 3, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 1280, Input_Conv, 1280, bias, 32, kernel, 1536, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 1280, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
 void Activation6(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	
	write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Conv1D_23(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_23:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 256; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_23:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_23:
			for (int k = 0; k < 32; k++){
				loop_for_fa_23:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[32*1*n+1*k+j])*(Input_Conv[40*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 256, 8);
	int pad_ctx = 0, n_ctx = 3, y_ctx = 0, k_ctx = 31, j_ctx = 0, alu_cfg_ctx = 1, stride_ctx = 0, s_ldm_ctx = 3, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 8, kernel, 256, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Conv1D_24(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_24:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 256; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_24:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_24:
			for (int k = 0; k < 32; k++){
				loop_for_fa_24:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[32*1*n+1*k+j])*(Input_Conv[40*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 256, 8);
	int pad_ctx = 0, n_ctx = 3, y_ctx = 0, k_ctx = 31, j_ctx = 0, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 8, kernel, 256, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
}
void Padding_Conv1D_25(float input_Pad_Conv[320], float output_Pad_Conv[336]){
	loop_for_3_channel_pad_25:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_25:
		for (int n = 0; n < 42; n++){
			if (n < 1 || n >= 41) output_Pad_Conv[42 * c + n]=0; else output_Pad_Conv[42 * c + n] = input_Pad_Conv[40 * c + n - 1];
		}
	}
}
void Conv1D_25(float Input_Conv[336],float Output_Conv[320], float bias[8], float kernel[192]){
	loop_for_channel_25:
	int stride = 1;
	
	for (int i = 0; i < 336; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 192; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_25:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_25:
			for (int k = 0; k < 8; k++){
				loop_for_fa_25:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[8*3*n+3*k+j])*(Input_Conv[42*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 192, 8);
	int pad_ctx = 1, n_ctx = 3, y_ctx = 0, k_ctx = 7, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 8;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 336, bias, 8, kernel, 192, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_26(float input_Pad_Conv[320], float output_Pad_Conv[352]){
	loop_for_3_channel_pad_26:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_26:
		for (int n = 0; n < 44; n++){
			if (n < 2 || n >= 42) output_Pad_Conv[44 * c + n]=0; else output_Pad_Conv[44 * c + n] = input_Pad_Conv[40 * c + n - 2];
		}
	}
}
void Conv1D_26(float Input_Conv[352],float Output_Conv[320], float bias[8], float kernel[320]){
	loop_for_channel_26:
	int stride = 1;
	
	for (int i = 0; i < 352; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 320; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_26:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_26:
			for (int k = 0; k < 8; k++){
				loop_for_fa_26:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[8*5*n+5*k+j])*(Input_Conv[44*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 320, 8);
	int pad_ctx = 2, n_ctx = 3, y_ctx = 0, k_ctx = 7, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 16;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 352, bias, 8, kernel, 320, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_27(float input_Pad_Conv[320], float output_Pad_Conv[368]){
	loop_for_3_channel_pad_27:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_27:
		for (int n = 0; n < 46; n++){
			if (n < 3 || n >= 43) output_Pad_Conv[46 * c + n]=0; else output_Pad_Conv[46 * c + n] = input_Pad_Conv[40 * c + n - 3];
		}
	}
}
void Conv1D_27(float Input_Conv[368],float Output_Conv[320], float bias[8], float kernel[448]){
	loop_for_channel_27:
	int stride = 1;
	
	for (int i = 0; i < 368; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 448; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_27:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_27:
			for (int k = 0; k < 8; k++){
				loop_for_fa_27:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[8*7*n+7*k+j])*(Input_Conv[46*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 448, 8);
	int pad_ctx = 3, n_ctx = 3, y_ctx = 0, k_ctx = 7, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 1, sa_ldm_ctx = 24;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 368, bias, 8, kernel, 448, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
 void Activation7(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
void Conv1D_28(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_28:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 256; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_28:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_28:
			for (int k = 0; k < 32; k++){
				loop_for_fa_28:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[32*1*n+1*k+j])*(Input_Conv[40*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 256, 8);
	int pad_ctx = 0, n_ctx = 3, y_ctx = 0, k_ctx = 31, j_ctx = 0, alu_cfg_ctx = 1, stride_ctx = 0, s_ldm_ctx = 1, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 8, kernel, 256, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Conv1D_29(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_29:
	int stride = 1;
	
	for (int i = 0; i < 1280; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 256; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_29:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_29:
			for (int k = 0; k < 32; k++){
				loop_for_fa_29:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[32*1*n+1*k+j])*(Input_Conv[40*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 256, 8);
	int pad_ctx = 0, n_ctx = 3, y_ctx = 0, k_ctx = 31, j_ctx = 0, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 1280, bias, 8, kernel, 256, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
}
void Padding_Conv1D_30(float input_Pad_Conv[320], float output_Pad_Conv[336]){
	loop_for_3_channel_pad_30:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_30:
		for (int n = 0; n < 42; n++){
			if (n < 1 || n >= 41) output_Pad_Conv[42 * c + n]=0; else output_Pad_Conv[42 * c + n] = input_Pad_Conv[40 * c + n - 1];
		}
	}
}
void Conv1D_30(float Input_Conv[336],float Output_Conv[320], float bias[8], float kernel[192]){
	loop_for_channel_30:
	int stride = 1;
	
	for (int i = 0; i < 336; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 192; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_30:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_30:
			for (int k = 0; k < 8; k++){
				loop_for_fa_30:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[8*3*n+3*k+j])*(Input_Conv[42*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 192, 8);
	int pad_ctx = 1, n_ctx = 3, y_ctx = 0, k_ctx = 7, j_ctx = 2, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 8;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 336, bias, 8, kernel, 192, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	
}
void Padding_Conv1D_31(float input_Pad_Conv[320], float output_Pad_Conv[352]){
	loop_for_3_channel_pad_31:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_31:
		for (int n = 0; n < 44; n++){
			if (n < 2 || n >= 42) output_Pad_Conv[44 * c + n]=0; else output_Pad_Conv[44 * c + n] = input_Pad_Conv[40 * c + n - 2];
		}
	}
}
void Conv1D_31(float Input_Conv[352],float Output_Conv[320], float bias[8], float kernel[320]){
	loop_for_channel_31:
	int stride = 1;
	
	for (int i = 0; i < 352; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 320; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_31:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_31:
			for (int k = 0; k < 8; k++){
				loop_for_fa_31:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[8*5*n+5*k+j])*(Input_Conv[44*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 320, 8);
	int pad_ctx = 2, n_ctx = 3, y_ctx = 0, k_ctx = 7, j_ctx = 4, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 16;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 352, bias, 8, kernel, 320, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Conv1D_32(float input_Pad_Conv[320], float output_Pad_Conv[368]){
	loop_for_3_channel_pad_32:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_32:
		for (int n = 0; n < 46; n++){
			if (n < 3 || n >= 43) output_Pad_Conv[46 * c + n]=0; else output_Pad_Conv[46 * c + n] = input_Pad_Conv[40 * c + n - 3];
		}
	}
}
void Conv1D_32(float Input_Conv[368],float Output_Conv[320], float bias[8], float kernel[448]){
	loop_for_channel_32:
	int stride = 1;
	
	for (int i = 0; i < 368; i++) {
		// printf("Input_Conv[%d] before: %f\n",i,Input_Conv[i]);
        Input_Conv[i] = fixedpoint_converter(Input_Conv[i]);
		// printf("Input_Conv[%d] after: %f\n",i,Input_Conv[i]);
    }
    for (int i = 0; i < 8; i++) {
        bias[i] = fixedpoint_converter(bias[i]);
    }
	for (int i = 0; i < 448; i++) {
        kernel[i] = fixedpoint_converter(kernel[i]);
    }
	
	for (int n = 0; n < 8; n++){
		loop_for_ap_32:
		for (int y = 0; y < 40; y++){
			float s = 0;
			loop_for_fc_32:
			for (int k = 0; k < 8; k++){
				loop_for_fa_32:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[8*7*n+7*k+j])*(Input_Conv[46*k+j+y*stride]);}
			}
			Output_Conv[40*n+y]=s+bias[n];
		}
	}
	
	for (int i = 0; i < 320; i++) {
        Output_Conv[i] = fixedpoint_converter(Output_Conv[i]);
    }
	
	write_bias_to_file(bias, 8);
    write_weight_to_file(kernel, 448, 8);
	int pad_ctx = 3, n_ctx = 3, y_ctx = 0, k_ctx = 7, j_ctx = 6, alu_cfg_ctx = 5, stride_ctx = 0, s_ldm_ctx = 0, d_ldm_ctx = 2, sa_ldm_ctx = 24;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	
		rtl_exact_conv1d_q6(Output_Conv, 320, Input_Conv, 368, bias, 8, kernel, 448, stride, j_ctx + 1, alu_cfg_ctx);

	finalize_conv_output_for_rtl(Output_Conv, 320, alu_cfg_ctx);

	dump_golden_ctx(__func__, Output_Conv, 320, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
 void Activation8(float Input_Activation[1280], float Output_Activation[1280]){
	for (int i = 0; i < 1280; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
	
	// write_to_file("Output_Conv.txt", Output_Activation, 1280);
}
 void Add2D_2(float input_0[1280], float input_1[1280], float output[1280]) {
	int size =1280;
	dump_golden_extra_parts(__func__, "input0_relu8_before_add", input_0, 1280, 320);
	dump_golden_extra_parts(__func__, "input1_residual_before_add", input_1, 1280, 320);
	for (int i = 0; i < size; i++){
		output[i] = input_0[i] + input_1[i];
	}
	write_to_file("Output_Conv.txt", output, 1280);
	int pad_ctx = 0, n_ctx = 7, y_ctx = 3, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 2, stride_ctx = 0, s_ldm_ctx = 2, d_ldm_ctx = 0, sa_ldm_ctx = 0;
    uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);

	dump_golden_extra_parts(__func__, "output_after_add", output, 1280, 320);
}


void Padding_Pool_0(float input_Pad_Pool[1280], float output_Pad_Pool[2568]){
	loop_for_3_channel_pad_0:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_0:
		for (int n = 0; n < 321; n++){
			if (n >= 321) output_Pad_Pool[321 * c + n]=0; else output_Pad_Pool[321 * c + n] = input_Pad_Pool[160 * c + n];
			// printf("output_Pad_Pool[%d] = input_Pad_Pool[%d] from PE %d, LDM depth = %d, Data = %f\n",321 * c + n,160 * c + n, (160 * c + n)%20,(160 * c + n)/20, input_Pad_Pool[160 * c + n]);
		}
	}
}
void Max_Pool1D_0(float input_MaxPooling[2568], float output_MaxPooling[1280]){
	int PoolSize = 3;
	int stride= 1;
	int index = 0;
	loop_for_channel_pool_0:
	for (int z = 0; z < 8; z++){
		index = 0;
		loop_for_weight_pool_0:
		for (int y = 0; y < 160; y++){
			float max = -10;
			for (int j = 0; j < PoolSize; j++)
			{
				int pool_index = 321 * z + j + y * stride;
				float pool_value = input_MaxPooling[pool_index];
				
				// printf("input_MaxPooling[%d], Data = %f\n",pool_index, input_MaxPooling[pool_index]);
				if (pool_value > max) max=pool_value;
			}
			int out_index = 160 * z + index;
			output_MaxPooling[out_index]=max;
			index++;
		}
	}
	
		// write_to_file("Output_Conv.txt", output_MaxPooling, 1280);
		
		int pad_ctx = 0, n_ctx = 7, y_ctx = 3, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 3, stride_ctx = 0, s_ldm_ctx = 3, d_ldm_ctx = 0, sa_ldm_ctx = 0;

		// Call the function to concatenate inputs into a 28-bit output
		uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
		write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output_MaxPooling, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Pool_1(float input_Pad_Pool[1280], float output_Pad_Pool[1296]){
	loop_for_3_channel_pad_1:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_1:
		for (int n = 0; n < 162; n++){
			if (n < 1 || n >= 161){
				output_Pad_Pool[162 * c + n]=0; 
				// printf("output_Pad_Pool[%d] = padding from PE %d, Data = 0\n",162 * c + n,(160 * c + n - 1 + 20)%20);
			}			
			else {
				output_Pad_Pool[162 * c + n] = input_Pad_Pool[160 * c + n - 1];
			// printf("output_Pad_Pool[%d] = input_Pad_Pool[%d] from PE %d, LDM depth = %d, Data = %f\n",162 * c + n,160 * c + n - 1, (160 * c + n - 1)%20,(160 * c + n - 1)/20, input_Pad_Pool[160 * c + n - 1]);
			}
		}
	}
		
}
void Max_Pool1D_1(float input_MaxPooling[1296], float output_MaxPooling[1280]){
	int PoolSize = 3;
	int stride= 1;
	int index = 0;
	loop_for_channel_pool_1:
	for (int z = 0; z < 8; z++){
		index = 0;
		loop_for_weight_pool_1:
		for (int y = 0; y < 160; y++){
			float max = -10;
			for (int j = 0; j < PoolSize; j++)
			{
				int pool_index = 162 * z + j + y * stride;
				float pool_value = input_MaxPooling[pool_index];
				if (pool_value > max) max=pool_value;
			}
			int out_index = 160 * z + index;
			output_MaxPooling[out_index]=max;
			index++;
		}
	}
	// write_to_file("Output_Conv.txt", output_MaxPooling, 1280);
	int pad_ctx = 1, n_ctx = 7, y_ctx = 3, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 3, stride_ctx = 0, s_ldm_ctx = 1, d_ldm_ctx = 0, sa_ldm_ctx = 0;

		// Call the function to concatenate inputs into a 28-bit output
		uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
		write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output_MaxPooling, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Pool_2(float input_Pad_Pool[1280], float output_Pad_Pool[1312]){
	loop_for_3_channel_pad_2:
	for (int c = 0; c < 16; c++){
		loop_for_channel_pad_2:
		for (int n = 0; n < 82; n++){
			if (n < 1 || n >= 81) output_Pad_Pool[82 * c + n]=0; else output_Pad_Pool[82 * c + n] = input_Pad_Pool[80 * c + n - 1];
		}
	}
}
void Max_Pool1D_2(float input_MaxPooling[1312], float output_MaxPooling[1280]){
	int PoolSize = 3;
	int stride= 1;
	int index = 0;
	loop_for_channel_pool_2:
	for (int z = 0; z < 16; z++){
		index = 0;
		loop_for_weight_pool_2:
		for (int y = 0; y < 80; y++){
			float max = -10;
			for (int j = 0; j < PoolSize; j++)
			{
				int pool_index = 82 * z + j + y * stride;
				float pool_value = input_MaxPooling[pool_index];
				if (pool_value > max) max=pool_value;
			}
			int out_index = 80 * z + index;
			output_MaxPooling[out_index]=max;
			index++;
		}
	}
	
		// write_to_file("Output_Conv.txt", output_MaxPooling, 1280);
		int pad_ctx = 1, n_ctx = 15, y_ctx = 1, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 3, stride_ctx = 0, s_ldm_ctx = 3, d_ldm_ctx = 0, sa_ldm_ctx = 0;

		// Call the function to concatenate inputs into a 28-bit output
		uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
		write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output_MaxPooling, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Pool_3(float input_Pad_Pool[1280], float output_Pad_Pool[1312]){
	loop_for_3_channel_pad_3:
	for (int c = 0; c < 16; c++){
		loop_for_channel_pad_3:
		for (int n = 0; n < 82; n++){
			if (n < 1 || n >= 81) output_Pad_Pool[82 * c + n]=0; else output_Pad_Pool[82 * c + n] = input_Pad_Pool[80 * c + n - 1];
		}
	}
}
void Max_Pool1D_3(float input_MaxPooling[1312], float output_MaxPooling[1280]){
	int PoolSize = 3;
	int stride= 1;
	int index = 0;
	loop_for_channel_pool_3:
	for (int z = 0; z < 16; z++){
		index = 0;
		loop_for_weight_pool_3:
		for (int y = 0; y < 80; y++){
			float max = -10;
			for (int j = 0; j < PoolSize; j++)
			{
				int pool_index = 82 * z + j + y * stride;
				float pool_value = input_MaxPooling[pool_index];
				if (pool_value > max) max=pool_value;
			}
			int out_index = 80 * z + index;
			output_MaxPooling[out_index]=max;
			index++;
		}
	}
	
	int pad_ctx = 1, n_ctx = 15, y_ctx = 1, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 3, stride_ctx = 0, s_ldm_ctx = 2, d_ldm_ctx = 0, sa_ldm_ctx = 0;

		// Call the function to concatenate inputs into a 28-bit output
		uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
		write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output_MaxPooling, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Pool_4(float input_Pad_Pool[1280], float output_Pad_Pool[1344]){
	loop_for_3_channel_pad_4:
	for (int c = 0; c < 32; c++){
		loop_for_channel_pad_4:
		for (int n = 0; n < 42; n++){
			if (n < 1 || n >= 41) output_Pad_Pool[42 * c + n]=0; else output_Pad_Pool[42 * c + n] = input_Pad_Pool[40 * c + n - 1];
		}
	}
}
void Max_Pool1D_4(float input_MaxPooling[1344], float output_MaxPooling[1280]){
	int PoolSize = 3;
	int stride= 1;
	int index = 0;
	loop_for_channel_pool_4:
	for (int z = 0; z < 32; z++){
		index = 0;
		loop_for_weight_pool_4:
		for (int y = 0; y < 40; y++){
			float max = -10;
			for (int j = 0; j < PoolSize; j++)
			{
				int pool_index = 42 * z + j + y * stride;
				float pool_value = input_MaxPooling[pool_index];
				if (pool_value > max) max=pool_value;
			}
			int out_index = 40 * z + index;
			output_MaxPooling[out_index]=max;
			index++;
		}
	}
	
	int pad_ctx = 1, n_ctx = 31, y_ctx = 0, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 3, stride_ctx = 0, s_ldm_ctx = 3, d_ldm_ctx = 0, sa_ldm_ctx = 0;

		// Call the function to concatenate inputs into a 28-bit output
		uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
		write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output_MaxPooling, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
}
void Padding_Pool_5(float input_Pad_Pool[1280], float output_Pad_Pool[1344]){
	loop_for_3_channel_pad_5:
	for (int c = 0; c < 32; c++){
		loop_for_channel_pad_5:
		for (int n = 0; n < 42; n++){
			if (n < 1 || n >= 41) output_Pad_Pool[42 * c + n]=0; else output_Pad_Pool[42 * c + n] = input_Pad_Pool[40 * c + n - 1];
		}
	}
}
void Max_Pool1D_5(float input_MaxPooling[1344], float output_MaxPooling[1280]){
	int PoolSize = 3;
	int stride= 1;
	int index = 0;
	loop_for_channel_pool_5:
	for (int z = 0; z < 32; z++){
		index = 0;
		loop_for_weight_pool_5:
		for (int y = 0; y < 40; y++){
			float max = -10;
			for (int j = 0; j < PoolSize; j++)
			{
				int pool_index = 42 * z + j + y * stride;
				float pool_value = input_MaxPooling[pool_index];
				if (pool_value > max) max=pool_value;
			}
			int out_index = 40 * z + index;
			output_MaxPooling[out_index]=max;
			index++;
		}
	}
	
	int pad_ctx = 1, n_ctx = 31, y_ctx = 0, k_ctx = 0, j_ctx = 0, alu_cfg_ctx = 3, stride_ctx = 0, s_ldm_ctx = 1, d_ldm_ctx = 0, sa_ldm_ctx = 0;

	// Call the function to concatenate inputs into a 28-bit output
	uint32_t result = concatenate_to_32bit(pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx, alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_context_to_file( &result, 1);

	dump_golden_ctx(__func__, output_MaxPooling, 1280, result,
	                pad_ctx, n_ctx, y_ctx, k_ctx, j_ctx,
	                alu_cfg_ctx, stride_ctx, s_ldm_ctx, d_ldm_ctx, sa_ldm_ctx);
	write_vivado_golden("Golden_Final_Layer42.txt", output_MaxPooling, 1280);
}

// Function to convert a 16-bit fixed-point hex value to a float
float fixed_point_to_float(int16_t fixed_point_value) {
    int sign = (fixed_point_value & 0x8000) ? -1 : 1;
    int16_t magnitude = (fixed_point_value & 0x7FFF); // Mask to get 15-bit magnitude
    float float_value = (float)magnitude / SCALE_FACTOR;
    return sign * float_value;
}

void GlobalAveragePool1D(float input_GlobalAveragePool1D[1280], float output_GlobalAveragePool1D[32]) {
    for (int i = 0; i < 32; i++) {
        float avg = 0.0f;
        for (int j = 0; j < 40; j++) {
            avg += input_GlobalAveragePool1D[40 * i + j];
        }
        output_GlobalAveragePool1D[i] = avg / 40.0f;
    }

	dump_golden_post(__func__, output_GlobalAveragePool1D, 32);
}

void Dense_0(float input_Dense[32],float &output_Dense,float bias[5],float weight[160]){
	float out_Dense[5];

    for (int i = 0; i < 160; i++) {
        fprintf(file1, "%f\n", weight[i]);
    }

    fclose(file1);

    for (int i = 0; i < 5; i++) {
        fprintf(file2, "%f\n", bias[i]);
    }

    fclose(file2);
	
	loop_for_a_Dense_0:
	for (int i = 0; i < 5; i++){
		float s=0;
		loop_for_b_Dense_0:
		for (int j = 0; j < 32; j++){
			s+=input_Dense[j]*weight[j*5+i];
		}
		out_Dense[i]=s+bias[i];
	}
	
	dump_golden_post(__func__, out_Dense, 5);

int maxindex = 0;
	float max=out_Dense[0];
	loop_detect:
	for (int i=0; i<5; i++){
		if (out_Dense[i]> max) {
			max=out_Dense[i];
			maxindex=i;
		}
	}
	output_Dense = maxindex;
	

}
