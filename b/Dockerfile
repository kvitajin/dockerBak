FROM ubuntu:18.04
WORKDIR /root
RUN apt update && apt install -y \
ocl-icd-opencl-dev \
ocl-icd-libopencl1 \
opencl-headers \
mesa-opencl-icd \
mesa-utils \
clinfo \
curl  \
apt-utils
COPY rocm.sh rocm.sh
RUN chmod +x rocm.sh
RUN ./rocm.sh





