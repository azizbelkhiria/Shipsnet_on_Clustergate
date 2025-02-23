import numpy as np
import pandas as pd
import json
import time
import os
import onnxruntime as ort
from sklearn.metrics import accuracy_score

# Use Docker's mounted output directory
os.makedirs('/app/output', exist_ok=True)
print("Output directory created: /app/output")

# Load test data from Docker path
with open('/app/shipsnet_20.json', 'r') as f:
    data = json.load(f)
X_test = np.array(data['data']).reshape(-1, 80, 80, 3) / 255.0  # Preprocess: Normalize to [0, 1]
y_test = np.array(data['labels'])
print(f"Loaded {X_test.shape[0]} test samples")

# Load ONNX model from Docker path
session = ort.InferenceSession('/app/shipsnet_new.onnx')
input_name = session.get_inputs()[0].name
output_name = session.get_outputs()[0].name
print("ONNX model loaded")

timings = []
for i in range(X_test.shape[0]):
    timing = {'image_id': i}
    input_data = X_test[i:i+1].astype(np.float32)  # Float32 input
    start = time.time()
    outputs = session.run([output_name], {input_name: input_data})
    timing['total_inference'] = time.time() - start
    timings.append(timing)
    pred_label = np.argmax(outputs[0][0])
    if i == 0:
        preds_labels = [pred_label]
    else:
        preds_labels.append(pred_label)
print(f"Ran inference on {len(timings)} images")

quantized_accuracy = accuracy_score(y_test, preds_labels)
df = pd.DataFrame(timings)
df = df[['image_id', 'total_inference']]
df.to_csv('/app/output/inference_timings.csv', index=False)  # Docker output path
print("CSV saved to /app/output/inference_timings.csv")

print(f"Quantized Accuracy: {quantized_accuracy:.4f}")
print(f"Average total inference time per image: {df['total_inference'].mean():.6f} seconds")
print("Total inference timings saved to /app/output/inference_timings.csv")
print("Note: Layer-specific timings not available; this is total execution time.")