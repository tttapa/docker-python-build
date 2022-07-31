FROM ubuntu:bionic

ARG GCC_VERSION

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update -y && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    add-apt-repository ppa:git-core/ppa && \
    apt-get update -y && \
    apt-get install -y \
        gcc-${GCC_VERSION} g++-${GCC_VERSION} gfortran-${GCC_VERSION} \
        ninja-build cmake bison git \
        autotools-dev automake libpcre3-dev libopenblas-dev \
        zlib1g-dev libbz2-dev libssl-dev uuid-dev libffi-dev libreadline-dev \
        libsqlite3-dev libbz2-dev libncurses5-dev libreadline6-dev \
        libgdbm-dev libgdbm-compat-dev liblzma-dev wget && \
    apt-get clean autoclean && \
    apt-get autoremove -y && \
    rm -rf /var/lib/apt/lists/*

COPY gcc.sh .
RUN chmod +x gcc.sh && ./gcc.sh ${GCC_VERSION}

RUN gcc --version

ARG PYTHON_VERSION

COPY python.sh .
RUN chmod +x python.sh && ./python.sh ${PYTHON_VERSION}

RUN python3 --version

ENV GCC_VERSION=${GCC_VERSION}
ENV PYTHON_VERSION=${PYTHON_VERSION}

RUN version=3.23.3; \
    wget https://github.com/Kitware/CMake/releases/download/v$version/cmake-$version-Linux-x86_64.sh && \
    bash cmake-$version-*.sh --skip-license --prefix="/usr/local" && \
    rm cmake-$version-*.sh
