#!/usr/bin/env bash

# git clone https://github.com/pytorch/pytorch.git
git clone https://github.com/ROCmSoftwarePlatform/pytorch.git pytorch-rocm
cd pytorch-rocm
git checkout 5d6e0907684c6f508c471505b5eee943bbf2dfde # 1.1.0a0+e6991ed
git submodule update --init --recursive
