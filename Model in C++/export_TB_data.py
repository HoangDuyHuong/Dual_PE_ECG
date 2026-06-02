import os
import numpy as np
import pandas as pd
import wfdb

dict_label = {"N": 0, "L": 1, "R": 2, "V": 3, "A": 4}

waveform_dir = "../dataset/dataset"
csv_path = "../train_test_cp/test_data.csv"

df = pd.read_csv(csv_path)


with open("signal_HDH.txt", "w") as fx, open("label_HDH.txt", "w") as fy:
    for _, row in df.iterrows():
        raw_signal, _ = wfdb.rdsamp(os.path.join(waveform_dir, str(row["filename_lr"])))
        channel_idx = int(row["channel"])
        start_idx = int(row["start"])
        end_idx = int(row["end"])

        raw_signal = raw_signal[start_idx:end_idx, channel_idx]

        if len(raw_signal) < 320:
            raw_signal = np.pad(raw_signal, (0, 320 - len(raw_signal)), "constant")
        else:
            raw_signal = raw_signal[:320]

        waveform = np.nan_to_num(raw_signal).reshape(-1)

        fx.write(" ".join(str(float(v)) for v in waveform))
        fx.write("\n")

        label = row["Label"][0]
        fy.write(str(dict_label[label]))
        fy.write("\n")