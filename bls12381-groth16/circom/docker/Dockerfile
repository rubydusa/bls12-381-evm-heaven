FROM node:16

# Install system dependencies
RUN apt-get update && \
    apt-get install -y build-essential curl

# Install Rust and Cargo
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# Install circom
RUN git clone https://github.com/iden3/circom.git && \
    cd circom && \
    cargo build --release && \
    cargo install --path circom

# Install snarkjs
RUN npm install -g snarkjs

# Set working directory
WORKDIR /app

RUN mkdir -p /app/out

# Copy circuit and script files
COPY . .

# Install node dependencies
RUN cd node && npm install

# Make scripts executable
RUN chmod +x entrypoint.sh
RUN chmod +x prove.sh
RUN chmod +x vk.sh

# Entrypoint
ENTRYPOINT ["./entrypoint.sh"]