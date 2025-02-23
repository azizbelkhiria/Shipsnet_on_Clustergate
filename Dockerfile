FROM sw-img-1-armv8:latest
WORKDIR /app
COPY wheels/protobuf-5.28.2-py3-none-any.whl /app/wheels/
COPY wheels/flatbuffers-24.3.25-py2.py3-none-any.whl /app/wheels/
COPY wheels/packaging-24.2-py3-none-any.whl /app/wheels/
COPY wheels/humanfriendly-10.0-py2.py3-none-any.whl /app/wheels/
COPY wheels/coloredlogs-15.0.1-py2.py3-none-any.whl /app/wheels/
COPY wheels/sympy-1.12-py3-none-any.whl /app/wheels/
COPY wheels/mpmath-1.3.0-py3-none-any.whl /app/wheels/
COPY wheels/onnxruntime-1.19.2-cp39-cp39-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl /app/wheels/
RUN python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/protobuf-5.28.2-py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/flatbuffers-24.3.25-py2.py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/packaging-24.2-py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/humanfriendly-10.0-py2.py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/coloredlogs-15.0.1-py2.py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/mpmath-1.3.0-py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/sympy-1.12-py3-none-any.whl && \
    python3.9 -m pip install --no-index --find-links=/app/wheels/ /app/wheels/onnxruntime-1.19.2-cp39-cp39-manylinux_2_27_aarch64.manylinux_2_28_aarch64.whl
COPY shipsnet_new.onnx /app/  
COPY shipsnet_20.json /app/
COPY inference.py /app/
ENTRYPOINT ["python3.9"]
CMD ["inference.py"]