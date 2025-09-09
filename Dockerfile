FROM ubuntu:22.04

# Prevent tzdata and other packages from prompting
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC

# Install required languages and tools
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

# Install Rust (non-interactive, no path prompts)
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs \
    | sh -s -- -y --no-modify-path < /dev/null
# Install Rust (non-interactive) and set global PATH
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Elixir + Erlang
RUN apt-get update && apt-get install -y erlang elixir

# Prepare workspace
WORKDIR /benchmark
COPY . .

# Make scripts executable
RUN chmod +x compile.sh benchmark.sh

# Compile all programs during build so they’re ready at runtime
    # Compile all programs at build time, ensuring Rust is in PATH
    # Compile all programs at build time
    RUN ./compile.sh

# Run benchmarks when container starts
CMD ["./benchmark.sh"]
