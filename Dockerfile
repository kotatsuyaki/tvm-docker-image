FROM nvidia/cuda:11.7.0-devel-ubuntu22.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y git llvm software-properties-common && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y python3.8 python3.8-distutils && \
    git clone --recursive https://github.com/apache/tvm tvm && \
    cd /tvm && \
    git checkout v0.9.0 && \
    apt-get install -y python3 python3-dev python3-setuptools gcc libtinfo-dev zlib1g-dev build-essential cmake ninja-build libedit-dev libxml2-dev && \
    mkdir /tvm/build && \
    cp /tvm/cmake/config.cmake /tvm/build/ && \
    sed -i 's/set(USE_CUDA OFF)/set(USE_CUDA ON)/g;s/set(USE_LLVM OFF)/set(USE_LLVM ON)/g' /tvm/build/config.cmake && \
    cd /tvm/build && \
    cmake .. -G Ninja && \
    ninja && \
    ninja install && \
    cd /tvm/python && \
    python3.8 setup.py install && \
    rm -rf /tvm
