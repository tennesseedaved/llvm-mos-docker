# Use an Ubuntu base image that supports ARM64 architecture
FROM ubuntu:latest as builder

# Install git, cmake, and any other necessary build tools
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    ninja-build \
    build-essential \
    python3 \
    vim \
    && rm -rf /var/lib/apt/lists/*

# Clone llvm-mos resus
RUN git clone https://github.com/llvm-mos/llvm-mos.git
RUN git clone https://github.com/llvm-mos/llvm-mos-sdk.git

WORKDIR /llvm-mos

# Attempt to run the cmake build command, ensuring that failure does not stop the build
# We remove the generator option for simplicity; you can add it as needed
RUN cmake -C clang/cmake/caches/MOS.cmake -S llvm -B build || echo "Build failed, but continuing."
RUN make -C build && make -C build install

WORKDIR /llvm-mos-sdk

RUN cmake -G "Ninja" -DCMAKE_INSTALL_PREFIX=/usr/local -B build
RUN ninja install -C build

# Use the same base image for the final stage
FROM ubuntu:latest

# Copy the repository (and potentially built files) to the final image
COPY --from=builder /usr/local /usr/local

# The Dockerfile does not fail if the cmake command fails, but prints "Build failed, but continuing."
# This CMD keeps the container running and allows users to exec into it to check the build or continue working.
CMD [ "tail", "-f", "/dev/null" ]

