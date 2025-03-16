## Solidity Groth16 BLS12-381 Verifier Docker Image

Functionalities:
- Generate verification key + solidity verifier contract
- Generate proof calldata

## Warning

Groth16 circuits in production require a trusted setup ceremony.

## Usage

```bash
docker build -t groth16-circom docker
```

```bash
docker run -it groth16-circom vk
```

```bash
docker run -it groth16-circom prove
```