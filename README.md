# Spack Package for VTR

[Verilog to Routing (VTR)](https://github.com/verilog-to-routing/vtr-verilog-to-routing) is a widely-used open-source CAD flow for exploring and targeting diverse FPGA architectures.

This repo demonstrates the proof-of-concept of building VTR using Spack on some outdated platforms (which are too old to get dependencies right with legacy methods):

```bash
cd /path/to/vtr-spack-package/
docker build -t vtr-poc-centos --build-arg OS_BASE=centos --build-arg OS_VERSION=centos7 .
docker build -t vtr-poc-ubuntu --build-arg OS_BASE=ubuntu --build-arg OS_VERSION=18.04 .
```

## Usage

To build VTR (in CentOS 7 for example):

```bash
# 1) Install essential requirements for Spack
yum install -y git python3 gcc gcc-c++ make patch bzip2 unzip time

# 2) Get Spack from GitHub
git clone https://github.com/spack/spack.git

# 3) Activate Spack
. /path/to/spack/share/spack/setup-env.sh

# 4) Config compilers
spack compiler find

# 5) (optional) Add C++14 compiler (e.g., GCC7)
spack install -j$(nproc) gcc@7
spack compiler add $(spack location -i gcc@7)

# 6) Install VTR
spack install -j$(nproc) vtr

# 7) Load VTR before using it
spack load vtr

# 8) Test VTR
cd $VTR_ROOT
./run_reg_test.py parmys_reg_basic
./vtr_flow/scripts/run_vtr_task.py regression_tests/vtr_reg_basic/basic_timing
```

Note: For Step 6, only after https://github.com/spack/spack/pull/39298 is merged into the Spack mainstream, can users install VTR directly through `spack install vtr`. Otherwise, please manually copy the `/path/to/vtr-spack-package/package.py` file to the Spack local codebase at `/path/to/spack/var/spack/repos/builtin/packages/vtr/` first, and install VTR via `spack install vtr` then.

In theory, this method of building VTR can be applied to **any platform** that supports Python 3 and Spack.

For more usages of Spack, please refer to https://spack.readthedocs.io/.