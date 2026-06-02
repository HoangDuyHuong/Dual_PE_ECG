import re

def update_conv_file():
    input_file = 'Conv.cpp'
    output_file = 'Conv_DualPE.cpp'

    try:
        with open(input_file, 'r', encoding='utf-8') as f:
            content = f.read()
    except FileNotFoundError:
        print(f"Lỗi: Không tìm thấy file {input_file}!")
        return

    # 1. Thay thế 2 hàm write_weight_to_file và write_bias_to_file ở đầu file
    start_idx = content.find("void write_weight_to_file(float data[], int length)")
    end_idx = content.find("// Function to write data to file in \"address_data\" format\nvoid write_context_to_file")

    if start_idx == -1 or end_idx == -1:
        print("Lỗi: Không tìm thấy block hàm ghi file. Hãy kiểm tra lại file Conv.cpp")
        return

    new_write_funcs = """void write_weight_to_file(float data[], int length, int N) {
    int KJ = length / N;
    for (int p = 0; p < N / 2; p++) {
        for (int kj = 0; kj < KJ; kj++) {
            // Channel cho PEA 0 (Số chẵn)
            int idx0 = (2 * p) * KJ + kj;
            fprintf(weight_file, "%04x\\n", FX_convert(data[idx0]) & 0xFFFF);
            weight_addr++;

            // Channel cho PEA 1 (Số lẻ)
            int idx1 = (2 * p + 1) * KJ + kj;
            fprintf(weight_file, "%04x\\n", FX_convert(data[idx1]) & 0xFFFF);
            weight_addr++;
        }
    }
}

void write_bias_to_file(float data[], int length) {
    int N = length;
    for (int p = 0; p < N / 2; p++) {
        // Bias cho PEA 0
        fprintf(bias_file, "%04x\\n", FX_convert(data[2 * p]) & 0xFFFF);
        bias_addr++;
        
        // Bias cho PEA 1
        fprintf(bias_file, "%04x\\n", FX_convert(data[2 * p + 1]) & 0xFFFF);
        bias_addr++;
    }
}

"""
    # Thay thế text
    content = content[:start_idx] + new_write_funcs + content[end_idx:]

    # 2. Cập nhật các lời gọi hàm write_weight_to_file để chèn thêm tham số N
    # Hàm write_bias_to_file(bias, N) luôn đứng trước, nên ta bắt giá trị N từ đó
    def replace_calls(match):
        n_val = match.group(1)
        len_val = match.group(2)
        return f"write_bias_to_file(bias, {n_val});\n    write_weight_to_file(kernel, {len_val}, {n_val});"

    content = re.sub(r"write_bias_to_file\(bias,\s*(\d+)\);\s*write_weight_to_file\(kernel,\s*(\d+)\);", replace_calls, content)

    # 3. Cập nhật biến n_ctx cho Context RAM
    # CHỈ chia đôi n_ctx nếu đó là lớp MAC (alu_cfg_ctx = 1 hoặc 5)
    def replace_ctx(match):
        pad = match.group(1)
        n = int(match.group(2))
        y = match.group(3)
        k = match.group(4)
        j = match.group(5)
        alu = int(match.group(6))
        
        if alu == 1 or alu == 5:
            new_n = (n + 1) // 2 - 1
        else:
            new_n = n  # Add2D và MaxPool giữ nguyên

        return f"int pad_ctx = {pad}, n_ctx = {new_n}, y_ctx = {y}, k_ctx = {k}, j_ctx = {j}, alu_cfg_ctx = {alu}"

    content = re.sub(r"int pad_ctx = (\d+), n_ctx = (\d+), y_ctx = (\d+), k_ctx = (\d+), j_ctx = (\d+), alu_cfg_ctx = (\d+)", replace_ctx, content)

    # Ghi ra file mới
    with open(output_file, 'w', encoding='utf-8') as f:
        f.write(content)

    print(f"Đã cập nhật thành công và lưu vào {output_file}!")

if __name__ == "__main__":
    update_conv_file()