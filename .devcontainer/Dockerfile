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

# Install NATS.c
RUN git clone https://github.com/nats-io/nats.c.git && \
    cd nats.c && \
    cmake -B build && \
    cmake --build build --target install && \
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
