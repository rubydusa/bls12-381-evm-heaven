#!/bin/bash

# Check if circuit name is provided as parameter
if [ $# -ne 1 ]; then
    echo "Usage: $0 <circuit.circom>"
    exit 1
fi

# Check if circuit file exists
if [ ! -f "$1" ]; then
    echo "Error: Circuit file $1 does not exist"
    exit 1
fi

cp $1 circuit.circom

# Step 1: Compile the circuit to generate r1cs, wasm and sym files
circom circuit.circom --r1cs --wasm --prime bls12381
# Step 2: Create a new powersOfTau ceremony for bls12381 curve
# Create a new powersOfTau ceremony for bls12381 curve
snarkjs powersoftau new bls12381 10 pot_0000.ptau
# Contribute to the ceremony (add entropy)
snarkjs powersoftau contribute pot_0000.ptau pot_0001.ptau --name="God" --entropy="nothingisreal"
# Apply a deterministic beacon
snarkjs powersoftau beacon pot_0001.ptau pot_beacon.ptau 0102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f 10
# Prepare phase 2
snarkjs powersoftau prepare phase2 pot_beacon.ptau pot_final.ptau

# Step 3: Generate the proving key and verification key
# Uses Groth16 proving system to create the zkey file
snarkjs groth16 setup circuit.r1cs pot_final.ptau circuit.zkey
# Export the verification key
snarkjs zkey export verificationkey circuit.zkey verification_key.json

# Step 4: Process the verification key for solidity template
python3 process_verification_key.py verification_key.json verification_key_solidity.json

# Step 5: Render the solidity verifier
node node/render.js verification_key_solidity.json Groth16VerifierBLS12381.sol

# Step 6: Copy files to output directory
cp Groth16VerifierBLS12381.sol /app/out/
cp verification_key.json /app/out/
cp verification_key_solidity.json /app/out/
cp circuit.zkey /app/out/
