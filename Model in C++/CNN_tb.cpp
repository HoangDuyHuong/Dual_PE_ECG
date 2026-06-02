#define _CRT_SECURE_NO_WARNINGS
#include <conio.h>
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <string>
#include <fstream>
#include <iostream>
#include "CNN.h"
#include "Conv.h"
#include "Pool.h"
#include "Dense.h"
#define NumberOfPicture 15009
#define d 1

int main(){
	float  OutModel0[5];
	float* Weights = (float*)malloc(6457 * sizeof(float));
	float tmp;
	FILE* Weight = fopen("Float_Weights.txt", "r");
	for (int i = 0; i < 6457; i++){
		fscanf(Weight, "%f", &tmp);
		*(Weights + i)=tmp;
	}
	fclose(Weight);
	////read Input
	float* InModel = (float*)malloc((NumberOfPicture * d * 320 * 1) * sizeof(float));
	FILE* Input = fopen("signal_HDH.txt", "r");
	for (int i = 0; i < NumberOfPicture * d * 320 * 1; i++){
		fscanf(Input, "%f", &tmp);
		*(InModel + i)=tmp;
	}
	fclose(Input);
	//Read Label
	float*Label = (float*)malloc((NumberOfPicture * 5) * sizeof(float));
	FILE* Output = fopen("label_HDH.txt", "r");
	for (int i = 0; i < NumberOfPicture * 5 ; i++)
	{
		fscanf(Output, "%f", &tmp);
		*(Label + i) = tmp;
	}
	fclose(Output);

	float Image[320] = {};
	float countTrue = 0;

	for (int i = 0; i < NumberOfPicture; i++)
	{
		int startIndex = i * 320;

		for (int k = 0; k < 320; k++)
		{
			Image[k] = *(InModel + startIndex + k);
		}

		CNN(Image, OutModel0, Weights);

		int pred = 0;
		float best = OutModel0[0];
		for (int j = 1; j < 5; j++)
		{
			if (OutModel0[j] > best)
			{
				best = OutModel0[j];
				pred = j;
			}
		}

		int labelValue = *(Label + i);

		if (i < 10)
		{
			std::cout << "logits = [";
			for (int j = 0; j < 5; j++)
			{
				std::cout << OutModel0[j];
				if (j < 4) std::cout << ", ";
			}
			std::cout << "], pred = " << pred
					<< ", label = " << labelValue << "\n";
		}

		if (labelValue == pred)
		{
			countTrue = countTrue + 1;
		}
	}

	float accuracy = (float)((countTrue / NumberOfPicture) * 100);
	std::cout << "accuracy of Model: " << accuracy << "%\n";
	return 0;
	}
