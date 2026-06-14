#include "CNN.h"
#include <iostream>
#include <fstream>
#include <sstream>
#include <string>
#include <vector>
#include <cstdlib>
#include <algorithm>

#define SIGNAL_LEN 320
#define WEIGHT_LEN 6457

static bool read_sample_line(
    const std::string& filename,
    int target_sample,
    float InModel[SIGNAL_LEN]
) {
    std::ifstream fin(filename);
    if (!fin.is_open()) {
        std::cout << "Cannot open " << filename << "\n";
        return false;
    }

    std::string line;
    int numeric_row = 0;

    while (std::getline(fin, line)) {
        // Bỏ dòng trắng
        if (line.find_first_not_of(" \t\r\n") == std::string::npos) {
            continue;
        }

        // Nếu file là CSV, đổi dấu phẩy thành khoảng trắng
        std::replace(line.begin(), line.end(), ',', ' ');

        std::istringstream iss(line);
        std::vector<float> vals;
        float x;

        while (iss >> x) {
            vals.push_back(x);
        }

        // Bỏ qua dòng không có số, ví dụ header
        if (vals.empty()) {
            continue;
        }

        if ((int)vals.size() != SIGNAL_LEN) {
            std::cout << "WARNING: numeric row " << numeric_row
                      << " has " << vals.size()
                      << " values, expected " << SIGNAL_LEN << "\n";
        }

        if (numeric_row == target_sample) {
            if ((int)vals.size() < SIGNAL_LEN) {
                std::cout << "ERROR: target sample row has fewer than 320 values\n";
                return false;
            }

            for (int i = 0; i < SIGNAL_LEN; i++) {
                InModel[i] = vals[i];
            }

            std::cout << "Selected numeric row/sample index = "
                      << target_sample << "\n";
            std::cout << "First 5 input values: ";
            for (int i = 0; i < 5; i++) {
                std::cout << InModel[i] << " ";
            }
            std::cout << "\n";

            return true;
        }

        numeric_row++;
    }

    std::cout << "ERROR: cannot find sample index " << target_sample << "\n";
    std::cout << "Total numeric rows found = " << numeric_row << "\n";
    return false;
}

int main(int argc, char* argv[]) {
    float InModel[SIGNAL_LEN];
    float OutModel = 0.0f;
    float Weights[WEIGHT_LEN];

    int target_sample = 0;
    if (argc >= 2) {
        target_sample = std::atoi(argv[1]);
    }

    std::string signal_file = "signal_HDH.txt";
    if (argc >= 3) {
        signal_file = argv[2];
    }

    if (!read_sample_line(signal_file, target_sample, InModel)) {
        return 1;
    }

    std::ifstream fin_weight("Float_Weights.txt");
    if (!fin_weight.is_open()) {
        std::cout << "Cannot open Float_Weights.txt\n";
        return 1;
    }

    for (int i = 0; i < WEIGHT_LEN; i++) {
        if (!(fin_weight >> Weights[i])) {
            std::cout << "ERROR: cannot read weight " << i << "\n";
            return 1;
        }
    }
    fin_weight.close();

    CNN(InModel, OutModel, Weights);

    std::cout << "Generated memory files.\n";
    std::cout << "OutModel = " << OutModel << "\n";

    return 0;
}