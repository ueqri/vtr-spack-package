# docker build -t vtr-poc-centos --build-arg OS_BASE=centos --build-arg OS_VERSION=centos7 .
# docker build -t vtr-poc-ubuntu --build-arg OS_BASE=ubuntu --build-arg OS_VERSION=18.04 .

ARG OS_BASE=centos
ARG OS_VERSION=centos7
FROM ${OS_BASE}:${OS_VERSION}

ARG OS_BASE

RUN if [ "${OS_BASE}" = "centos" ]; then \
    yum install -y git python3 gcc gcc-c++ make patch bzip2 unzip time; \
    elif [ "${OS_BASE}" = "ubuntu" ]; then \
    apt update && apt install -y git python3 build-essential patch bzip2 unzip time; \
    else echo "Unknown platform!" && exit; \
    fi

COPY package.py vtr_spack_package.py

RUN git clone https://github.com/spack/spack.git
RUN alias python="env python3" && \
    . spack/share/spack/setup-env.sh && \
    spack compiler find && \
    spack install -j128 gcc@7:9 && \
    spack compiler add $(spack location -i gcc) && \
    spack create --name vtr --skip-editor

RUN alias python="env python3" && \
    . spack/share/spack/setup-env.sh && \
    mv vtr_spack_package.py $(spack location -p vtr)/package.py && \
    spack install -j128 vtr

RUN alias python="env python3" && \
    . spack/share/spack/setup-env.sh && \
    spack load vtr && \
    echo $VTR_ROOT > vtr_root_path
    # ./vtr_flow/scripts/run_vtr_task.py \
    # regression_tests/vtr_reg_basic/basic_timing

SHELL ["/bin/bash", "-c"]
