#!/usr/bin/env bash

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
git checkout 5d6e0907684c6f508c471505b5eee943bbf2dfde # 1.1.0a0+e6991ed
git submodule update --init --recursive

#python3 tools/amd_build/build_pytorch_amd.py
#python3 tools/amd_build/build_caffe2_amd.py
python3 tools/amd_build/build_amd.py

python3 setup.py install
pip3 install torchvision

