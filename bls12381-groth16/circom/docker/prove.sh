#!/bin/bash

# Check if circuit name and input file are provided as parameters
if [ $# -ne 4 ]; then
    echo "Usage: $0 <circuit.circom> <verification_key.json> <circuit.zkey> <input.json>"
    exit 1
fi

# Check if circuit file exists
if [ ! -f "$1" ]; then
    echo "Error: Circuit file $1 does not exist"
    exit 1
fi

# Check if verification key file exists
if [ ! -f "$2" ]; then
    echo "Error: Verification key file $2 does not exist"
    exit 1
fi

# Check if input file exists
if [ ! -f "$4" ]; then
    echo "Error: Input file $4 does not exist"
    exit 1
fi

# Copy input file to working directory
cp "$1" circuit.circom
cp "$2" verification_key.json
cp "$3" circuit.zkey
cp "$4" input.json

# Step 1: Compile the circuit to generate wasm artifacts
circom circuit.circom --wasm --prime bls12381

# Step 2: Generate a witness
node circuit_js/generate_witness.js circuit_js/circuit.wasm input.json witness.wtns

# Step 3: Generate a proof using Groth16
snarkjs groth16 prove circuit.zkey witness.wtns proof.json public.json

# Step 4: Verify the proof
snarkjs groth16 verify verification_key.json public.json proof.json

# Step 5: Generate calldata for solidity verification
python3 generate_proof_calldata.py proof.json public.json calldata.json

# Step 6: Copy files to output directory
cp calldata.json /app/out/