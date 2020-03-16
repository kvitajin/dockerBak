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
COPY rocm2.sh rocm2.sh
COPY rocm3.sh rocm3.sh
COPY rocm4.sh rocm4.sh
COPY rocm5.sh rocm5.sh


RUN chmod +x rocm.sh && ./rocm.sh
RUN chmod +x rocm2.sh && ./rocm2.sh
RUN chmod +x rocm3.sh && ./rocm3.sh
RUN chmod +x rocm4.sh && ./rocm4.sh
RUN chmod +x rocm5.sh && ./rocm5.sh






