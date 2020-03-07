FROM ubuntu:18.04
WORKDIR /root
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
    ocl-icd-opencl-dev \
    ocl-icd-libopencl1 \
    opencl-headers \
    mesa-opencl-icd \
    mesa-utils \
    clinfo \
    curl  \
    apt-utils
COPY rocm.sh rocm.sh
RUN chmod +x rocm.sh && ./rocm.sh





