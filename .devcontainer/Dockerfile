FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    cmake \
    build-essential \
    curl \
    wget \
    unzip \
    python3 \
    python3-pip \
    sox \
    ffmpeg \
    alsa-utils \
    libasound2-dev \
    libsdl2-dev \
    libssl-dev \
    # Dependencies for building NATS
    libtool \
    automake \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /root/ros2_ws

# Install NATS.c properly with all necessary steps
RUN git clone https://github.com/nats-io/nats.c.git && \
    cd nats.c && \
    mkdir build && \
    cd build && \
    cmake .. \
        -DNATS_BUILD_WITH_TLS=ON \
        -DNATS_BUILD_EXAMPLES=ON \
        -DBUILD_SHARED_LIBS=ON && \
    make && \
    make install && \
    cd ../.. && \
    rm -rf nats.c && \
    ldconfig

# Build whisper.cpp from the mounted code
# WORKDIR /root/ros2_ws/whisper.cpp
# RUN mkdir -p build && \
#     cd build && \
#     cmake -DWHISPER_SDL2=ON .. && \
#     make -j

# # Download the model (you can change this to base.en or small.en)
# WORKDIR /root/ros2_ws/whisper.cpp
# RUN ./models/download-ggml-model.sh tiny.en

# Add alias for whisper-command with model path
RUN echo 'alias whisper-command="/root/ros2_ws/whisper.cpp/build/bin/whisper-command -m /root/ros2_ws/whisper.cpp/models/ggml-tiny.en.bin"' >> /root/.bashrc

# Set default working directory
WORKDIR /root/ros2_ws/whisper.cpp

# Default command: open a bash shell
CMD ["/bin/bash"]
