void Padding_Conv1D_0(float input_Pad_Conv[320], float output_Pad_Conv[326]){
	loop_for_3_channel_pad_0:
	for (int c = 0; c < 1; c++){
		loop_for_channel_pad_0:
		for (int n = 0; n < 326; n++){
			if (n < 3 || n >= 323) output_Pad_Conv[326 * c + n]=0; else output_Pad_Conv[326 * c + n] = input_Pad_Conv[320 * c + n - 3];
		}
	}
}
void Conv1D_0(float Input_Conv[326],float Output_Conv[2560], float bias[8], float kernel[56]){
	loop_for_channel_0:
	int stride = 1;
	for (int n = 0; n < 8; n++){
		loop_for_ap_0:
		for (int y = 0; y < 320; y++){
			float s = 0;
			loop_for_fc_0:
			for (int k = 0; k < 1; k++){
				loop_for_fa_0:
				for (int j = 0; j < 7; j++){
					s=s+(kernel[1*7*n+7*k+j])*(Input_Conv[326*k+j+y*stride]);}
			}
			Output_Conv[320*n+y]=s+bias[n];
		}
	}
}
 void Activation0(float Input_Activation[2560], float Output_Activation[2560]){
	for (int i = 0; i < 2560; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
}
void Conv1D_1(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_1:
	int stride = 1;
	for (int n = 0; n < 2; n++){
		loop_for_ap_1:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_1:
			for (int k = 0; k < 8; k++){
				loop_for_fa_1:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[8*1*n+1*k+j])*(Input_Conv[160*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
}
void Conv1D_2(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_2:
	int stride = 1;
	for (int n = 0; n < 2; n++){
		loop_for_ap_2:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_2:
			for (int k = 0; k < 8; k++){
				loop_for_fa_2:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[8*1*n+1*k+j])*(Input_Conv[160*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
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
	for (int n = 0; n < 2; n++){
		loop_for_ap_3:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_3:
			for (int k = 0; k < 2; k++){
				loop_for_fa_3:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[2*3*n+3*k+j])*(Input_Conv[162*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
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
	for (int n = 0; n < 2; n++){
		loop_for_ap_4:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_4:
			for (int k = 0; k < 2; k++){
				loop_for_fa_4:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[2*5*n+5*k+j])*(Input_Conv[164*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
}
void Padding_Conv1D_5(float input_Pad_Conv[320], float output_Pad_Conv[332]){
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
}
 void Concatenate_0(float input_0[320], float input_1[320], float input_2[320], float input_3[320], float output[1280]) {
	for (int i = 0; i < 320;i++){
		output[0 + i] = input_0[i];
	}
	for (int i = 0; i < 320;i++){
		output[320 + i] = input_1[i];
	}
	for (int i = 0; i < 320;i++){
		output[640 + i] = input_2[i];
	}
	for (int i = 0; i < 320;i++){
		output[960 + i] = input_3[i];
	}

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
}
void Conv1D_6(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_6:
	int stride = 1;
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
}
void Conv1D_7(float Input_Conv[1280],float Output_Conv[320], float bias[2], float kernel[16]){
	loop_for_channel_7:
	int stride = 1;
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
}
void Padding_Conv1D_8(float input_Pad_Conv[320], float output_Pad_Conv[324]){
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
}
 void Concatenate_1(float input_0[320], float input_1[320], float input_2[320], float input_3[320], float output[1280]) {
	for (int i = 0; i < 320;i++){
		output[0 + i] = input_0[i];
	}
	for (int i = 0; i < 320;i++){
		output[320 + i] = input_1[i];
	}
	for (int i = 0; i < 320;i++){
		output[640 + i] = input_2[i];
	}
	for (int i = 0; i < 320;i++){
		output[960 + i] = input_3[i];
	}

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
}
void Add_0(float input_0[1280], float input_1[1280], float output[1280]) {
	for (int i = 0; i < 1280; i++){
		output[i] = input_0[i] + input_1[i];
	}
}
void Padding_Conv1D_11(float input_Pad_Conv[1280], float output_Pad_Conv[1312]){
	loop_for_3_channel_pad_11:
	for (int c = 0; c < 8; c++){
		loop_for_channel_pad_11:
		for (int n = 0; n < 164; n++){
			if (n < 2 || n >= 162) output_Pad_Conv[164 * c + n]=0; else output_Pad_Conv[164 * c + n] = input_Pad_Conv[160 * c + n - 2];
		}
	}
}
void Conv1D_11(float Input_Conv[1312],float Output_Conv[2560], float bias[16], float kernel[640]){
	loop_for_channel_11:
	int stride = 1;
	for (int n = 0; n < 16; n++){
		loop_for_ap_11:
		for (int y = 0; y < 160; y++){
			float s = 0;
			loop_for_fc_11:
			for (int k = 0; k < 8; k++){
				loop_for_fa_11:
				for (int j = 0; j < 5; j++){
					s=s+(kernel[8*5*n+5*k+j])*(Input_Conv[164*k+j+y*stride]);}
			}
			Output_Conv[160*n+y]=s+bias[n];
		}
	}
}
 void Activation3(float Input_Activation[2560], float Output_Activation[2560]){
	for (int i = 0; i < 2560; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
}
void Conv1D_12(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_12:
	int stride = 1;
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
}
void Conv1D_13(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_13:
	int stride = 1;
	for (int n = 0; n < 4; n++){
		loop_for_ap_13:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_13:
			for (int k = 0; k < 16; k++){
				loop_for_fa_13:
				for (int j = 0; j < 1; j++){
					s=s+(kernel[16*1*n+1*k+j])*(Input_Conv[80*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
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
}
 void Concatenate_2(float input_0[320], float input_1[320], float input_2[320], float input_3[320], float output[1280]) {
	for (int i = 0; i < 320;i++){
		output[0 + i] = input_0[i];
	}
	for (int i = 0; i < 320;i++){
		output[320 + i] = input_1[i];
	}
	for (int i = 0; i < 320;i++){
		output[640 + i] = input_2[i];
	}
	for (int i = 0; i < 320;i++){
		output[960 + i] = input_3[i];
	}

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
}
void Conv1D_17(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_17:
	int stride = 1;
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
}
void Conv1D_18(float Input_Conv[1280],float Output_Conv[320], float bias[4], float kernel[64]){
	loop_for_channel_18:
	int stride = 1;
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
}
 void Concatenate_3(float input_0[320], float input_1[320], float input_2[320], float input_3[320], float output[1280]) {
	for (int i = 0; i < 320;i++){
		output[0 + i] = input_0[i];
	}
	for (int i = 0; i < 320;i++){
		output[320 + i] = input_1[i];
	}
	for (int i = 0; i < 320;i++){
		output[640 + i] = input_2[i];
	}
	for (int i = 0; i < 320;i++){
		output[960 + i] = input_3[i];
	}

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
}
void Add_1(float input_0[1280], float input_1[1280], float output[1280]) {
	for (int i = 0; i < 1280; i++){
		output[i] = input_0[i] + input_1[i];
	}
}
void Padding_Conv1D_22(float input_Pad_Conv[1280], float output_Pad_Conv[1312]){
	loop_for_3_channel_pad_22:
	for (int c = 0; c < 16; c++){
		loop_for_channel_pad_22:
		for (int n = 0; n < 82; n++){
			if (n < 1 || n >= 81) output_Pad_Conv[82 * c + n]=0; else output_Pad_Conv[82 * c + n] = input_Pad_Conv[80 * c + n - 1];
		}
	}
}
void Conv1D_22(float Input_Conv[1312],float Output_Conv[2560], float bias[32], float kernel[1536]){
	loop_for_channel_22:
	int stride = 1;
	for (int n = 0; n < 32; n++){
		loop_for_ap_22:
		for (int y = 0; y < 80; y++){
			float s = 0;
			loop_for_fc_22:
			for (int k = 0; k < 16; k++){
				loop_for_fa_22:
				for (int j = 0; j < 3; j++){
					s=s+(kernel[16*3*n+3*k+j])*(Input_Conv[82*k+j+y*stride]);}
			}
			Output_Conv[80*n+y]=s+bias[n];
		}
	}
}
 void Activation6(float Input_Activation[2560], float Output_Activation[2560]){
	for (int i = 0; i < 2560; i++){
		if(Input_Activation[i] > 0){
			Output_Activation[i] = Input_Activation[i];
		}else
		{
			Output_Activation[i] = 0;
		}
	}
}
void Conv1D_23(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_23:
	int stride = 1;
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
}
void Conv1D_24(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_24:
	int stride = 1;
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
}
 void Concatenate_4(float input_0[320], float input_1[320], float input_2[320], float input_3[320], float output[1280]) {
	for (int i = 0; i < 320;i++){
		output[0 + i] = input_0[i];
	}
	for (int i = 0; i < 320;i++){
		output[320 + i] = input_1[i];
	}
	for (int i = 0; i < 320;i++){
		output[640 + i] = input_2[i];
	}
	for (int i = 0; i < 320;i++){
		output[960 + i] = input_3[i];
	}

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
}
void Conv1D_28(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_28:
	int stride = 1;
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
}
void Conv1D_29(float Input_Conv[1280],float Output_Conv[320], float bias[8], float kernel[256]){
	loop_for_channel_29:
	int stride = 1;
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
}
 void Concatenate_5(float input_0[320], float input_1[320], float input_2[320], float input_3[320], float output[1280]) {
	for (int i = 0; i < 320;i++){
		output[0 + i] = input_0[i];
	}
	for (int i = 0; i < 320;i++){
		output[320 + i] = input_1[i];
	}
	for (int i = 0; i < 320;i++){
		output[640 + i] = input_2[i];
	}
	for (int i = 0; i < 320;i++){
		output[960 + i] = input_3[i];
	}

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
}
void Add_2(float input_0[1280], float input_1[1280], float output[1280]) {
	for (int i = 0; i < 1280; i++){
		output[i] = input_0[i] + input_1[i];
	}
}
