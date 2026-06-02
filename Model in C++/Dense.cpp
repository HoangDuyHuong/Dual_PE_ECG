void Dense_0(float input_Dense[32],float output_Dense[5],float bias[5],float weight[160]){
	float out_Dense[5];
	loop_for_a_Dense_0:
	for (int i = 0; i < 5; i++){
		float s=0;
		loop_for_b_Dense_0:
		for (int j = 0; j < 32; j++){
			s+=input_Dense[j]*weight[j*5+i];
		}
		out_Dense[i]=s+bias[i];
	}
	for (int i = 0; i < 5; i++){
		output_Dense[i] = out_Dense[i];
	}
}
