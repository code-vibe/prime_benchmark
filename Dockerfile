FROM ubuntu:22.04
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

RUN apt-get update && apt-get install -y \
    tzdata \
    build-essential \
    gcc g++ \
    default-jdk \
    mono-mcs mono-runtime \
    python3 python3-pip \
    nodejs npm \
    php php-cli \
    golang-go \
    curl wget \
    bc \
    util-linux \
    && rm -rf /var/lib/apt/lists/*


RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path < /dev/null

# Install Rust (non-interactive) and set global PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
ENV PATH="/root/.cargo/bin:${PATH}"

RUN apt-get update && apt-get install -y erlang elixir

WORKDIR /benchmark
COPY . .

RUN chmod +x compile.sh benchmark.sh

    # Compile all programs at build time
    RUN ./compile.sh

# Run benchmarks when container starts
CMD ["./benchmark.sh"]
