FROM ubuntu:24.04 AS build

ENV TZ=UTC
ENV LANG=C.UTF-8

# Install Required Dependencies
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    # Intall practicerom
    curl https://practicerom.com/public/packages/debian/pgp.pub | apt-key add - && \ 
    echo deb http://practicerom.com/public/packages/debian staging main >/etc/apt/sources.list.d/practicerom.list &&  \ 
    apt-get update && \
    apt-get install -y \
    curl \
    build-essential \
    binutils-mips-linux-gnu \
    pkg-config \
    python3 \
    python3-pip \
    python3-venv \
    git \
    wget \
    unzip \
    vbindiff \
    vim \
    clang-tidy-14 \
    clang-format-14 \
    libpng-dev && \
    practicerom-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /mm
RUN git config --global --add safe.directory /mm

CMD ["/bin/sh", "-c", \
    "make -j $(nproc) init && \
    echo Completed build. Open another terminal and run 'docker-compose exec mm sh' to shell into this running container. && \
    tail -f /dev/null"]