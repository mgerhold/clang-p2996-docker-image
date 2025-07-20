FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      ca-certificates \
      vim \
      nano \
      curl \
      gpg \
      wget \
      software-properties-common \
      git \
      build-essential && \
    rm -rf /var/lib/apt/lists/*

# Add Kitware APT repository for the latest CMake
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc \
      | gpg --dearmor \
      | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null && \
    echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ noble main' \
      | tee /etc/apt/sources.list.d/kitware.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends cmake kitware-archive-keyring && \
    rm -rf /var/lib/apt/lists/*

# Add deadsnakes PPA and install Python 3.13
RUN add-apt-repository -y ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends python3.13 && \
    rm -rf /var/lib/apt/lists/*

# Install ninja build system
RUN apt-get update && \
    apt-get install -y --no-install-recommends ninja-build && \
    rm -rf /var/lib/apt/lists/*

# Install uv package manager via install script
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    echo 'export PATH="$HOME/.uv/bin:$PATH"' >> /etc/profile.d/uv.sh

WORKDIR /usr/src
RUN git clone https://github.com/bloomberg/clang-p2996.git

WORKDIR /usr/src/clang-p2996
RUN git switch p2996
RUN cmake -S llvm -B build -G Ninja \
      -DLLVM_ENABLE_PROJECTS="clang" \
      -DCMAKE_BUILD_TYPE=Release \
      -DLLVM_ENABLE_RUNTIMES="libcxx;libcxxabi;libunwind" \
      -DCLANG_DEFAULT_CXX_STDLIB=libc++

RUN cmake --build build -j$(nproc)

ENV PATH=/usr/src/clang-p2996/build/bin:$PATH
ENV LD_LIBRARY_PATH=/usr/src/clang-p2996/build/lib/x86_64-unknown-linux-gnu

RUN update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.12 1 && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.13 2

RUN apt-get update && \
    apt-get install -y python-is-python3 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
      gdb && \
    rm -rf /var/lib/apt/lists/*

COPY LICENSES/ /licenses/

CMD ["/bin/bash"]
