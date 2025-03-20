// SPDX-License-Identifier: GPL-3.0
// Creator: Rubydusa 2025

pragma solidity >=0.7.0 <0.9.0;

interface IGroth16VerifierBLS12381Errors {
    error NotInField(uint256);
    error InvalidProofLength();
    error G1MSMFailed();
    error G1AddFailed();
    error PairingFailed();
}

interface IGroth16VerifierBLS12381 is IGroth16VerifierBLS12381Errors {
    function verifyProof(bytes calldata proof) external view returns (bool);
}