#include "CNN.h"
#include <iostream>
#include <fstream>

int main() {
    float InModel[320];
    float OutModel;
    float Weights[6457];

    std::ifstream fin_signal("signal_HDH.txt");
    if (!fin_signal.is_open()) {
        std::cout << "Cannot open signal_HDH.txt\n";
        return 1;
    }

    for (int i = 0; i < 320; i++) {
        fin_signal >> InModel[i];
    }
    fin_signal.close();

    std::ifstream fin_weight("Float_Weights.txt");
    if (!fin_weight.is_open()) {
        std::cout << "Cannot open Float_Weights.txt\n";
        return 1;
    }

    for (int i = 0; i < 6457; i++) {
        fin_weight >> Weights[i];
    }
    fin_weight.close();

    CNN(InModel, OutModel, Weights);

    std::cout << "Generated memory files.\n";
    std::cout << "Output = " << OutModel << "\n";

    return 0;
}