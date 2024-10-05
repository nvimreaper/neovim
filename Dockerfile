# ^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.
#
# Neovim builder from source

FROM ubuntu:22.04 AS builder

# Install neovim build dependencies:
# https://github.com/neovim/neovim/blob/master/BUILD.md#build-prerequisites
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
    ninja-build \
    gettext \
    cmake \
    unzip \
    curl \
    build-essential \
    libtool-bin \
    autoconf \
    automake \
    pkg-config \
    git \
    libncurses5-dev \
    g++ && rm -rf /var/lib/apt/lists/*

# Clone Neovim source code
RUN git clone https://github.com/neovim/neovim.git /neovim
WORKDIR /neovim

# Checkout the provided git tag
ARG TAG="stable"
RUN git checkout ${TAG}

# Build Neovim
RUN make CMAKE_BUILD_TYPE=Release

# Install Neovim to a temporary directory
RUN make install DESTDIR=/neovim/build

# ^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.^_^.
#
# Final image with Neovim install

FROM ubuntu:22.04

# Neovim runtime dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y \
    libtool-bin \
    gettext \
    libtermkey1 \
    libvterm0 \
    libunibilium4 \
    libmsgpackc2 \
    libluajit-5.1-2 \
    lua5.1 \
    libncurses5 \
    && rm -rf /var/lib/apt/lists/*

# Copy Neovim from the builder stage
COPY --from=builder /neovim/build/usr/local/ /usr/local/

# Set the entrypoint to Neovim
CMD ["nvim"]
