## Solidity Groth16 BLS12-381 Verifier Docker Image

Functionalities:
- Generate verification key + solidity verifier contract
- Generate proof calldata

## Warning

Groth16 circuits in production require a trusted setup ceremony.

## Build

```bash
docker build -t groth16-circom docker
```

## Usage

Before you can use the docker image, you need to have a circom circuit file. (`fib.circom` is provided as an example)

Then, you perform the following steps:
1. Generate the verification key and verifier contract
2. Generate the proof calldata

```bash
docker run -v ./out:/app/out \
    -v .:/app/data \
    groth16-circom vk \
    data/circuit.circom
```

```bash
docker run -v ./out:/app/out \
    -v .:/app/data \
    groth16-circom prove \
    data/fib.circom \
    data/out/verification_key.json \
    data/out/circuit.zkey \
    data/input.json
```

## TODO

- [ ] Add tests for the docker image