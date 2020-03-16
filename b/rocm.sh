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
