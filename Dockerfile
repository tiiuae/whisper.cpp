FROM ubuntu:22.04 AS build

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
WORKDIR /root/app

# Clone your specific repository and branch
RUN git clone -b feat/manpack https://github.com/tiiuae/whisper.cpp.git && \
    cd whisper.cpp && \
    git submodule update --init --recursive

# Install NATS.c
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

# Build whisper.cpp
WORKDIR /root/app/whisper.cpp
RUN mkdir -p build && \
    cd build && \
    cmake -DWHISPER_SDL2=ON .. && \
    make -j

# Download the model
RUN cd models && ./download-ggml-model.sh tiny.en

# Runtime stage
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install runtime dependencies
RUN apt-get update && apt-get install -y \
    ffmpeg \
    libsdl2-2.0-0 \
    libgomp1 \
    libssl3 \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /root/app

# Copy only necessary files from build stage
COPY --from=build /root/app/whisper.cpp /root/app/whisper.cpp
COPY --from=build /usr/local/lib/libnats.so* /usr/local/lib/

# Update library cache
RUN ldconfig

# Set environment variables
ENV PATH="/root/app/whisper.cpp/build/bin:${PATH}"
ENV NATS_URL="nats://localhost:4222"

# Default command with correct path
CMD ["/root/app/whisper.cpp/build/bin/whisper-command", "-m", "/root/app/whisper.cpp/models/ggml-tiny.en.bin", "--capture", "0"]
