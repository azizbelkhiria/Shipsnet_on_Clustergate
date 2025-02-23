# Deploying and benchmarking a ship detection neural net on Clustergate
This repository provides a simple demonstration of how to deploy a neural network on the Clustergate flight computer. We train a shallow convolutional neural network and quantize, then export it to ONNX for deploymen on Clustergate

### How to run the inference? 
To use the model within the docker container, you need to download the images from the private repository of DPhi Space. Reach out to contact@dphispace.com to get your credentials. 

Once the images is available, load it by executing the following command in the terminal:

```bash
docker load < sw-img-1-armv8.zip
```

Now you should have the following docker image available:

```bash
docker image ls | grep sw-img-1-armv8
> sw-img-1-armv8   latest            d789f30de192   2 hours ago    507MB
```

Once this is set up, you can build the Dockerfile given in this repository, which uses the **sw-img-1-armv8** base image and runs the inferece.py once started: 

```bash
docker build --platform linux/arm64 -f Dockerfile -t shipsnet-payload .
```

Create a directory /output/ and mount it to the local /app/output/ direcoty of the countainer to get the inference time per image. Then run the docke image with the following: 

```bash
mkdir -p ./output && docker run --rm -v ./output:/app/output shipsnet
```

You should get the following output:
```bash
Output directory created: /app/output
Loaded 20 test samples
ONNX model loaded
Ran inference on 20 images
CSV saved to /app/output/inference_timings.csv
Quantized Accuracy: 0.9000
Average total inference time per image: 0.000852 seconds
Total inference timings saved to /app/output/inference_timings.csv
Note: Layer-specific timings not available; this is total execution time.
```

We obtain the following numbers for the first 10 images when running the container on macOS 15.3.1, M2 8GB:

| Image ID | Total Inference (s) |
|----------|---------------------|
| 0        | 0.004641            |
| 1        | 0.000617            |
| 2        | 0.001731            |
| 3        | 0.000540            |
| 4        | 0.000589            |
| 5        | 0.000572            |
| 6        | 0.000573            |
| 7        | 0.000566            |
| 8        | 0.000579            |
| 9        | 0.000559            |