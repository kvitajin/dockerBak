#!/usr/bin/env bash
set -o xtrace

export DEBIAN_FRONTEND="noninteractive"

if [ "$(uname)" == 'Darwin' ]; then
  OS='MacOSX'
  echo "Your platform ( $OS ) is not supported."
  exit 1
elif [ "$(expr substr $(uname -s) 1 5)" == 'Linux' ]; then
  OS='Linux'
  echo "Detected Linux OS."
elif [ "$(expr substr $(uname -s) 1 10)" == 'MINGW32_NT' ]; then
  OS='Cygwin'
  echo "Your platform ( $OS ) is not supported."
  exit 1
else
  echo "Your platform ($(uname -a)) is not supported."
  exit 1
fi

IS_AVAILABLE_OS="NO"

OSSTR=$(cat /etc/os-release | grep "Ubuntu 16.04")
echo "Check OS ${OSSTR}"
if [ ${#OSSTR} == 0 ]; then
  echo "None"
else
  IS_AVAILABLE_OS="Ubuntu 16.04"
fi

OSSTR=$(cat /etc/os-release | grep "Ubuntu 18.04")
echo "Check OS ${OSSTR}"
if [ ${#OSSTR} == 0 ]; then
  echo "None"
else
  IS_AVAILABLE_OS="Ubuntu 18.04"
fi

if [ "$IS_AVAILABLE_OS" = "NO" ]; then
  echo "System must be Ubuntu 16.04 or Ubuntu 18.04"
  exit 1
fi

if [ "$IS_AVAILABLE_OS" = "Ubuntu 18.04" ]; then
  apt-get update && apt-get install -y --no-install-recommends curl gnupg2 software-properties-common && \
  add-apt-repository universe && \
  curl -sL http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list' && \
  curl -sL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main > /etc/apt/sources.list.d/llvm7.list' && \
  sh -c 'echo deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-7 main >> /etc/apt/sources.list.d/llvm7.list'
elif [ "$IS_AVAILABLE_OS" = "Ubuntu 16.04" ]; then
  apt-get update && apt-get install -y --no-install-recommends curl gnupg2 software-properties-common && \
  add-apt-repository universe && \
  curl -sL http://repo.radeon.com/rocm/apt/debian/rocm.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://repo.radeon.com/rocm/apt/debian/ xenial main > /etc/apt/sources.list.d/rocm.list' && \
  curl -sL https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add - && \
  sh -c 'echo deb [arch=amd64] http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main > /etc/apt/sources.list.d/llvm7.list' && \
  sh -c 'echo deb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-7 main >> /etc/apt/sources.list.d/llvm7.list'
else
  echo "System must be Ubuntu 16.04 or Ubuntu 18.04"
  exit 1
fi

apt-get update && apt-get install -y --no-install-recommends \
  libelf1 \
  build-essential \
  bzip2 \
  ca-certificates \
  cmake \
  ssh \
  apt-utils \
  pkg-config \
  g++-multilib \
  gdb \
  git \
  less \
  libunwind-dev \
  libfftw3-dev \
  libelf-dev \
  libncurses5-dev \
  libomp-dev \
  libpthread-stubs0-dev \
  make \
  miopen-hip \
  miopengemm \
  python3-dev \
  python3-future \
  python3-yaml \
  python3-pip \
  python3-setuptools \
  vim \
  libssl-dev \
  libboost-dev \
  libboost-system-dev \
  libboost-filesystem-dev \
  libopenblas-dev \
  rpm \
  wget \
  net-tools \
  iputils-ping \
  libnuma-dev \
  rocm-dev \
  rocrand \
  rocblas \
  rocfft \
  hipsparse \
  rccl \
  clang-7

apt-get clean &&
  rm -rf /var/lib/apt/lists/*

sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/rocsparse/lib/cmake/rocsparse/rocsparse-config.cmake
sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/rocfft/lib/cmake/rocfft/rocfft-config.cmake
sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/miopen/lib/cmake/miopen/miopen-config.cmake
sed -i 's/find_dependency(hip)/find_dependency(HIP)/g' /opt/rocm/rocblas/lib/cmake/rocblas/rocblas-config.cmake

prf=$(
  cat <<'EOF'
export HIP_VISIBLE_DEVICES=0
export HCC_HOME=/opt/rocm/hcc
export ROCM_PATH=/opt/rocm
export ROCM_HOME=/opt/rocm
export HIP_PATH=/opt/rocm/hip
export PATH=/usr/local/bin:$HCC_HOME/bin:$HIP_PATH/bin:$ROCM_PATH/bin:/opt/rocm/opencl/bin/x86_64:$PATH
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/rocm/opencl/lib/x86_64
export LC_ALL="en_US.UTF-8"
export LC_CTYPE="en_US.UTF-8"
export HIP_PLATFORM="hcc"
export KMTHINLTO="1"
export CUPY_INSTALL_USE_HIP=1
export MAKEFLAGS=-j8
export __HIP_PLATFORM_HCC__
export HIP_PLATFORM=hcc
export PLATFORM=hcc
export USE_ROCM=1
export MAX_JOBS=2
EOF
)

GFX=gfx900
export HCC_AMDGPU_TARGET=$GFX

echo "$prf" >>~/.profile
source ~/.profile

pip3 install cython pillow h5py numpy scipy requests sklearn matplotlib editdistance pandas portpicker jupyter pyyaml typing enum34 hypothesis

update-alternatives --install /usr/bin/gcc gcc /usr/bin/clang-7 50
update-alternatives --install /usr/bin/g++ g++ /usr/bin/clang++-7 50

# git clone https://github.com/pytorch/pytorch.git
git clone https://github.com/ROCmSoftwarePlatform/pytorch.git pytorch-rocm
cd pytorch-rocm
git checkout e6991ed29fec9a7b7ffb09b6ec58fb9d3fec3d22 # 1.1.0a0+e6991ed
git submodule init
git submodule update

#python3 tools/amd_build/build_pytorch_amd.py
#python3 tools/amd_build/build_caffe2_amd.py
python3 tools/amd_build/build_amd.py

python3 setup.py install
pip3 install torchvision

cd ~/
clinfo | grep '  Name:'
#python3 -c "import torch;print('CUDA(hip) is available',torch.cuda.is_available());print('cuda(hip)_device_num:',torch.cuda.device_count());print('Radeon device:',torch.cuda.get_device_name(torch.cuda.current_device()))"
