# BLS12-381 EVM Haven
This monorepo contains various projects using the Pectra BLS12-381 precompiles.

## Projects
- `bls12381-lib`: Solidity library for performing BLS12-381 elliptic curve arithemtic + Standardized BLS signature verification
- `bls12381-groth16`: Solidity Groth16 verifier template compatible with circom
- `validate-beacon-sig-on-chain-poc` (WIP): Validating beacon chain signatures on-chain 

## Setup
Setup submodules:
```bash
git submodule update --init --recursive
```


