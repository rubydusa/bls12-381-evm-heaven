# Validate Beacon Sig on Chain POC

## Overview

Using the new Pectra BLS precompiles, we can validate consensus layer signatures on-chain.

This could be useful for applications like an on-chain light client.

## TODO:
- [ ] Figure out how to use `eth2spec` to verify the attestation signature (validate only validators from first attestation for Proof of Concept)
- [ ] Implement smart contracts