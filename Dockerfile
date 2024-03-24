FROM nvcr.io/nvidia/cuda:12.2.0-devel-ubuntu22.04

RUN apt update && apt install -y vim-tiny git wget

# we could have installed this package 
# but it looks like it's easier to build because the downstream code wants source files
# libboost-all-dev

# this will be home for our work
RUN mkdir /workspace

WORKDIR /workspace

# boost from source. picking version 
ARG BOOST_VER=1_77_0
RUN wget https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source/boost_$BOOST_VER.tar.gz
RUN tar -zxvf boost_$BOOST_VER.tar.gz
WORKDIR /workspace/boost_$BOOST_VER
RUN ./bootstrap.sh
# RUN ./b2 install --prefix=/opt/boost
RUN ./b2 install

WORKDIR /workspace
RUN git clone https://github.com/DeltaGroupNJUPT/Vina-GPU-2.1.git
ADD QuickVina2-GPU-2.1/Makefile /workspace/Vina-GPU-2.1/QuickVina2-GPU-2.1/

WORKDIR /workspace/Vina-GPU-2.1/QuickVina2-GPU-2.1
RUN make clean 
RUN make source

RUN mkdir -p /etc/OpenCL/vendors
RUN echo "libnvidia-opencl.so.1" > /etc/OpenCL/vendors/nvidia.icd

# RUN THIS IF YOU WANT TO TRY IT OUT
# RUN ./Vina-GPU --config ./input_file_example/2bm2_config.txt
