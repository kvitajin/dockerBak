#!/usr/bin/env bash

#python3 tools/amd_build/build_pytorch_amd.py
#python3 tools/amd_build/build_caffe2_amd.py
python3 tools/amd_build/build_amd.py

python3 setup.py install
pip3 install torchvision

