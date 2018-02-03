# Build TensorFlow 1.3 with SSE4.1/SSE4.2/AVX/AVX2/FMA and NVIDIA CUDA support on macOS Sierra 10.12 (updated October 5, 2017)

These instructions were inspired by [Mistobaan](https://github.com/mistobaan)'s [gist](https://gist.github.com/Mistobaan/dd32287eeb6859c6668d#file-tensorflow_cuda_osx-md), [ageitgey](https://github.com/ageitgey)'s [gist](https://gist.github.com/ageitgey/819a51afa4613649bd18#file-build-tensorflow-on-osx-with-nvidia-cuda-support-md), and [mattiasarro](https://github.com/mattiasarro)'s [tutorial](https://medium.com/@mattias.arro/installing-tensorflow-1-2-from-sources-with-gpu-support-on-macos-4f2c5cab8186).

## Background
I always encountered the following warnings when running my scripts using the precompiled TensorFlow Python package:
```
W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use SSE4.1 instructions, but these are available on your machine and could speed up CPU computations.
W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use SSE4.2 instructions, but these are available on your machine and could speed up CPU computations.
W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use AVX instructions, but these are available on your machine and could speed up CPU computations.
W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use AVX2 instructions, but these are available on your machine and could speed up CPU computations.
W tensorflow/core/platform/cpu_feature_guard.cc:45] The TensorFlow library wasn't compiled to use FMA instructions, but these are available on your machine and could speed up CPU computations.
```
I realized I can make these warnings go away by [compiling from source](https://www.tensorflow.org/install/install_sources), in addition to improve training speed. It was not as easy and straightforward as I thought, but I finally succeeded in creating a working build. Here I outline the steps I took, in the hopes it may benefit those who have encountered similar challenges.

## Machine setup

### Hardware
- Model: MacBook Pro (Retina, 15-inch, Mid 2014)
- Processor: 2.5 GHz Intel Core i7
- Memory: 16 GB 1600 MHz DDR3
- Graphics: Intel Iris Pro 1536 MB RAM + NVIDIA GeForce GT 750M 2048 MB RAM

### Software
- OS: macOS Sierra 10.12.6
- TensorFlow version: 1.3.1
- Python version: 3.6.2 (conda)
- Bazel version: 0.6.0-homebrew
- CUDA/cuDNN version: 8.0/6.0

## Prerequisites

### macOS Sierra (10.12)

I tested on macOS Sierra 10.12. It may also work on Yosemite (10.10) and El Capitan (10.11), but I have not verified.

### Xcode Command-Line Tools

I successfully compiled using Xcode 8.2.1 (Refer to http://docs.nvidia.com/cuda/cuda-installation-guide-mac-os-x/index.html#system-requirements).

### Disable SIP (System Integrity Protection) on Mac

For some reason I had to [disable SIP](https://www.howtogeek.com/230424/how-to-disable-system-integrity-protection-on-a-mac-and-why-you-shouldnt/) in order for `bazel build` to build the TensorFlow pip package successfully. For security reasons, remember to re-enable SIP after your build.

## Steps

Note: Many steps were based on https://www.tensorflow.org/install/install_sources ; I just happened to have a slightly different order that worked out for me.

- Install [homebrew](https://brew.sh/)
- Install [bazel](https://bazel.build/versions/master/docs/install.html#mac-os-x)
- Install [conda](https://conda.io/miniconda.html) (I wanted a Python environment that will not mess with system Python. I downloaded Miniconda for Python 2.7 and intended to create a Python 3.6 environment)
- Create and activate Python 3.6 environment
  ```bash
  conda create --name compiletf python=3
  # wheel 0.29.0 will already be installed
  source activate compiletf
  conda install numpy six
  # numpy 1.13.1 and six 1.10.0 will have been installed
  ```
  Alternatively, you can do:
  ```bash
  conda create --name compiletf python=3 anaconda
  # numpy 1.12.1, six 1.10.0, and wheel 0.29.0 will already be installed
  source activate compiletf
  conda update numpy
  # numpy 1.13.1 will have been installed
  ```
- Verify that the following packages are installed:
  - `six`
  - `numpy`
   - has to be at least `1.13` so you don't get a `ModuleNotFoundError: No module named 'numpy.lib.mixins'` error later on during `bazel build`
  - `wheel`
- Install CUDA support prerequisites
  - Install GNU coreutils and swig
    ```bash
    brew install coreutils swig
    ```
  - Refer to [this](http://docs.nvidia.com/cuda/cuda-installation-guide-mac-os-x/index.html) for more detailed CUDA installation instructions.
  - Install [CUDA Toolkit 8.0](https://developer.nvidia.com/cuda-toolkit)
  - Install [cudNN 6.0](https://developer.nvidia.com/cudnn)
  - Set environment variable `DYLD_LIBRARY_PATH`
    ```bash
    export DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH
    ```
- Clone the TensorFlow repository ([instructions](https://www.tensorflow.org/install/install_sources#clone_the_tensorflow_repository)): be sure to checkout the `r1.3` release
  ```bash
  git clone https://github.com/tensorflow/tensorflow
  cd tensorflow
  git checkout r1.3
  ```
- Configure the installation
  ```bash
  bazel clean
  ./configure
  ```
  My `configure` settings (Enter `N` for CUDA support if you do not want CUDA support or do not have a NVIDIA GPU):
  ```
  Please specify the location of python. [Default is /Users/phil.wee/miniconda2/envs/compiletf/bin/python]:
  Found possible Python library paths:
    /Users/phil.wee/miniconda2/envs/compiletf/lib/python3.6/site-packages
  Please input the desired Python library path to use.  Default is [/Users/phil.wee/miniconda2/envs/compiletf/lib/python3.6/site-packages]

  Using python library path: /Users/phil.wee/miniconda2/envs/compiletf/lib/python3.6/site-packages
  Do you wish to build TensorFlow with MKL support? [y/N]
  No MKL support will be enabled for TensorFlow
  Please specify optimization flags to use during compilation when bazel option "--config=opt" is specified [Default is -march=native]:
  Do you wish to build TensorFlow with Google Cloud Platform support? [y/N]
  No Google Cloud Platform support will be enabled for TensorFlow
  Do you wish to build TensorFlow with Hadoop File System support? [y/N]
  No Hadoop File System support will be enabled for TensorFlow
  Do you wish to build TensorFlow with the XLA just-in-time compiler (experimental)? [y/N]
  No XLA support will be enabled for TensorFlow
  Do you wish to build TensorFlow with VERBS support? [y/N]
  No VERBS support will be enabled for TensorFlow
  Do you wish to build TensorFlow with OpenCL support? [y/N]
  No OpenCL support will be enabled for TensorFlow
  Do you wish to build TensorFlow with CUDA support? [y/N] Y
  CUDA support will be enabled for TensorFlow
  Do you want to use clang as CUDA compiler? [y/N]
  nvcc will be used as CUDA compiler
  Please specify the CUDA SDK version you want to use, e.g. 7.0. [Leave empty to default to CUDA 8.0]:
  Please specify the location where CUDA 8.0 toolkit is installed. Refer to README.md for more details. [Default is /usr/local/cuda]:
  Please specify which gcc should be used by nvcc as the host compiler. [Default is /usr/bin/gcc]:
  Please specify the cuDNN version you want to use. [Leave empty to default to cuDNN 6.0]:
  Please specify the location where cuDNN 6 library is installed. Refer to README.md for more details. [Default is /usr/local/cuda]:
  ./configure: line 669: /usr/local/cuda/extras/demo_suite/deviceQuery: No such file or directory
  Please specify a list of comma-separated Cuda compute capabilities you want to build with.
  You can find the compute capability of your device at: https://developer.nvidia.com/cuda-gpus.
  Please note that each additional compute capability significantly increases your build time and binary size.
  [Default is: "3.5,5.2"]: 3.0
  Do you wish to build TensorFlow with MPI support? [y/N]
  MPI support will not be enabled for TensorFlow
  Configuration finished
  ```
- Comment out `linkopts = ["-lgomp"],` (line 112) in `tensorflow/third_party/gpus/cuda/BUILD.tpl` (Refer to https://medium.com/@mattias.arro/installing-tensorflow-1-2-from-sources-with-gpu-support-on-macos-4f2c5cab8186)
- Build the pip package (reference: https://stackoverflow.com/questions/41293077/how-to-compile-tensorflow-with-sse4-2-and-avx-instructions). It took around 35 minutes on my MacBook Pro.
  ```bash
  export CUDA_HOME=/usr/local/cuda
  export DYLD_LIBRARY_PATH=$CUDA_HOME/lib:$CUDA_HOME/extras/CUPTI/lib
  export LD_LIBRARY_PATH=$DYLD_LIBRARY_PATH
  bazel build -c opt --copt=-mavx --copt=-mavx2 --copt=-mfma --copt=-msse4.1 --copt=-msse4.2 --config=cuda --action_env LD_LIBRARY_PATH --action_env DYLD_LIBRARY_PATH --verbose_failures -k //tensorflow/tools/pip_package:build_pip_package
  ```
- Refer to https://github.com/tensorflow/tensorflow/issues/6729 if you run into any other problems
- Build the wheel (.whl) file
  ```bash
  bazel-bin/tensorflow/tools/pip_package/build_pip_package /tmp/tensorflow_pkg
  ```
- Install the pip package
  ```bash
  pip install --upgrade --ignore-installed /tmp/tensorflow_pkg/tensorflow-1.3.1-cp36-cp36m-macosx_10_7_x86_64.whl
  ```
- Validate your installation ([instructions](https://www.tensorflow.org/install/install_sources#validate_your_installation))
  - Change directory to any directory on your system other than the `tensorflow` subdirectory from which you ran `./configure`
    ```bash
    cd ~
    ```
  - Invoke python interactive shell
    ```bash
    python
    ```
  - Type in the following script
    ```python
    import tensorflow as tf
    with tf.device('/gpu:0'):
        a = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[2, 3], name='a')
        b = tf.constant([1.0, 2.0, 3.0, 4.0, 5.0, 6.0], shape=[3, 2], name='b')
        c = tf.matmul(a, b)

    with tf.Session() as sess:
        print (sess.run(c))

    ```
    If you have a supported NVIDIA CUDA GPU, the script should run without a problem and display something similar to this:
    ```
    2017-10-05 22:22:27.025606: I tensorflow/stream_executor/cuda/cuda_gpu_executor.cc:857] OS X does not support NUMA - returning NUMA node zero
    2017-10-05 22:22:27.025798: I tensorflow/core/common_runtime/gpu/gpu_device.cc:955] Found device 0 with properties:
    name: GeForce GT 750M
    major: 3 minor: 0 memoryClockRate (GHz) 0.9255
    pciBusID 0000:01:00.0
    Total memory: 2.00GiB
    Free memory: 873.57MiB
    2017-10-05 22:22:27.025819: I tensorflow/core/common_runtime/gpu/gpu_device.cc:976] DMA: 0
    2017-10-05 22:22:27.025826: I tensorflow/core/common_runtime/gpu/gpu_device.cc:986] 0:   Y
    2017-10-05 22:22:27.025842: I tensorflow/core/common_runtime/gpu/gpu_device.cc:1045] Creating TensorFlow device (/gpu:0) -> (device: 0, name: GeForce GT 750M, pci bus id: 0000:01:00.0)
    [[ 22.  28.]
     [ 49.  64.]]
    ```

Have fun training your models!
