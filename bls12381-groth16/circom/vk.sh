#!/bin/bash

# Step 1: Compile the circuit to generate r1cs, wasm and sym files
# --r1cs: generates r1cs constraint system file
# --wasm: generates WebAssembly code
# --sym: generates symbols file for debugging
# --prime: specifies the prime field (bls12381 curve)
circom fib.circom --r1cs --wasm --sym --prime bls12381
# Create a new powersOfTau ceremony for bls12381 curve
snarkjs powersoftau new bls12381 10 pot_0000.ptau
# Contribute to the ceremony (add entropy)
snarkjs powersoftau contribute pot_0000.ptau pot_0001.ptau --name="God" --entropy="a"
# Apply a random beacon
snarkjs powersoftau beacon pot_0001.ptau pot_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10
# Prepare phase 2
snarkjs powersoftau prepare phase2 pot_beacon.ptau pot_final.ptau

# Step 3: Generate the proving key and verification key
# Uses Groth16 proving system to create the zkey file
snarkjs groth16 setup fib.r1cs pot_final.ptau fib_final.zkey
# Export the verification key
snarkjs zkey export verificationkey fib_final.zkey verification_key.json

# Create input file with a1=1, a2=1
echo '{"a1": 1, "a2": 1}' > input.json

# Step 4: Generate a witness
# First compile the circuit to generate witness generation binary
node fib_js/generate_witness.js fib_js/fib.wasm input.json witness.wtns

# Step 5: Generate a proof using Groth16
# Create the proof
snarkjs groth16 prove fib_final.zkey witness.wtns proof.json public.json

# Step 6: Verify the proof
snarkjs groth16 verify verification_key.json public.json proof.json
