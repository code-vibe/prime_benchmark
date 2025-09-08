FROM ubuntu:22.04

# Install all required languages
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc g++ \
    default-jdk \
    mono-mcs mono-runtime \
    python3 python3-pip \
    nodejs npm \
    php php-cli \
    golang-go \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install Elixir
RUN apt-get update && apt-get install -y wget
RUN wget https://packages.erlang-solutions.com/erlang-solutions_2.0_all.deb \
    && dpkg -i erlang-solutions_2.0_all.deb \
    && apt-get update \
    && apt-get install -y esl-erlang elixir

WORKDIR /benchmark
COPY . .

# Make scripts executable
RUN chmod +x compile.sh benchmark.sh

CMD ["./benchmark.sh"]