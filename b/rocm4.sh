#!/usr/bin/env bash

cd pytorch-rocm

#python3 tools/amd_build/build_pytorch_amd.py
#python3 tools/amd_build/build_caffe2_amd.py
python3 tools/amd_build/build_amd.py

pip3 install torchvision
python3 setup.py install

