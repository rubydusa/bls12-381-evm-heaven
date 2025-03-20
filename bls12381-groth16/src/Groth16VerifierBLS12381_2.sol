// SPDX-License-Identifier: GPL-3.0
// Author: Rubydusa 2025

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // precompiles
    uint256 constant G1_ADD_PRECOMPILE = 11;
    uint256 constant G1_MSM_PRECOMPILE = 12;
    uint256 constant PAIRING_PRECOMPILE = 15;
    // Main subgroup order
    uint256 constant q = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;

    // Verification Key data
    bytes32 constant alphax_0  = 0x000000000000000000000000000000001050fa9ca694fc2e0b477f1032e2aa2d;
    bytes32 constant alphax_1  = 0x2c370c128af404a3e55070e0f0463ed2df668a17e31f05ae80aadb9fb40f6475;
    bytes32 constant alphay_0  = 0x0000000000000000000000000000000018e9c85da9a04660f3e257c5146cfc1a;
    bytes32 constant alphay_1  = 0x8c623e839244bbd133707618ccba308f0ca5c44986919db2adcd36dad10d596c;
    
    bytes32 constant betax1_0  = 0x00000000000000000000000000000000127a02dc0d916b900a2568d65b19e2ed;
    bytes32 constant betax1_1  = 0x365e519982976a666700cf2112bff012758937fc4b5950d009628a6214b3c921;
    bytes32 constant betay1_0  = 0x000000000000000000000000000000000b2ea5b9a5e3e98c16ade221ead31f2d;
    bytes32 constant betay1_1  = 0x97116e74156eebf9bdf312bceefcc3e231a679e371ea457513713e0cc01b64a9;
    bytes32 constant betax2_0  = 0x00000000000000000000000000000000144783a199c41f810b19f008710dd5e9;
    bytes32 constant betax2_1  = 0xa013c12ff4005e10c924411aedd5e4e6b387ff1d8c513b0b827f3534b6ba1e6f;
    bytes32 constant betay2_0  = 0x00000000000000000000000000000000036f00ca7c74ffa01c70f8b0c07fc780;
    bytes32 constant betay2_1  = 0x18878a77057f3758b09f527ade8d74a6cf2d47ec3d7f34dd157f1601a0b0bbf9;

    bytes32 constant gammax1_0 = 0x00000000000000000000000000000000024aa2b2f08f0a91260805272dc51051;
    bytes32 constant gammax1_1 = 0xc6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8;
    bytes32 constant gammay1_0 = 0x0000000000000000000000000000000013e02b6052719f607dacd3a088274f65;
    bytes32 constant gammay1_1 = 0x596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e;
    bytes32 constant gammax2_0 = 0x000000000000000000000000000000000ce5d527727d6e118cc9cdc6da2e351a;
    bytes32 constant gammax2_1 = 0xadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801;
    bytes32 constant gammay2_0 = 0x000000000000000000000000000000000606c4a02ea734cc32acd2b02bc28b99;
    bytes32 constant gammay2_1 = 0xcb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be;

    bytes32 constant deltax1_0 = 0x00000000000000000000000000000000024aa2b2f08f0a91260805272dc51051;
    bytes32 constant deltax1_1 = 0xc6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb8;
    bytes32 constant deltay1_0 = 0x0000000000000000000000000000000013e02b6052719f607dacd3a088274f65;
    bytes32 constant deltay1_1 = 0x596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e;
    bytes32 constant deltax2_0 = 0x000000000000000000000000000000000ce5d527727d6e118cc9cdc6da2e351a;
    bytes32 constant deltax2_1 = 0xadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801;
    bytes32 constant deltay2_0 = 0x000000000000000000000000000000000606c4a02ea734cc32acd2b02bc28b99;
    bytes32 constant deltay2_1 = 0xcb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be;

    uint256 constant nPublic = 1;
    uint256 constant proofLength = 544;
    
    bytes32 constant IC0x_0 = 0x000000000000000000000000000000000456532bbe0b4e787a64b0e315b21626;
    bytes32 constant IC0x_1 = 0xf1e8e6c21cd65006fffd730bec6e259e3c628266fa3a48b0e04554f322075a56;
    bytes32 constant IC0y_0 = 0x000000000000000000000000000000000ece01c186c590fc1514e1f2e84923df;
    bytes32 constant IC0y_1 = 0x462e4d3a40fa22b5c07d6c32f11d34019c2d7bb731b05c3f53a2665d89757b00;
    
    bytes32 constant IC1x_0 = 0x00000000000000000000000000000000162d4db53161ea1f769e43ffd2c6cba6;
    bytes32 constant IC1x_1 = 0xad41b7560c1da875cecbf757a3e611f48b17081bf829eff218f1fb6cabfd1f5f;
    bytes32 constant IC1y_0 = 0x00000000000000000000000000000000064ad86c3c26497075edf1b2354a3580;
    bytes32 constant IC1y_1 = 0x6b7bf9ca0e4d6a742502eefe8c3482a922b72d85f23f12d255daf3b4acb88479;
    

    bytes4 constant ERROR_NOT_IN_FIELD = 0x81452424;  // cast sig "NotInField(uint256)"
    bytes4 constant ERROR_INVALID_PROOF_LENGTH = 0x4dc5f6a4;  // cast sig "InvalidProofLength()"
    bytes4 constant ERROR_G1_MSM_FAILED = 0x5f776986;  // cast sig "G1MSMFailed()"
    bytes4 constant ERROR_G1_ADD_FAILED = 0xd6cc76eb;  // cast sig "G1AddFailed()"
    bytes4 constant ERROR_PAIRING_FAILED = 0x4df45e2f;  // cast sig "PairingFailed()"

    // proof structure:
    // negA: 128 bytes
    // B: 256 bytes
    // C: 128 bytes
    // pubSignals: 32 * nPublic bytes
    function verifyProof(bytes calldata proof) public view returns (bool){
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, ERROR_NOT_IN_FIELD)
                    mstore(4, v)
                    revert(0, 0x24)
                }
            }

            // check proof length
            if iszero(eq(proof.length, proofLength)) {
                mstore(0, ERROR_INVALID_PROOF_LENGTH)
                revert(0, 0x04)
            }

            let tmp := 0
            let o := proof.offset
            // msm of pub signals (skipping IC0)
            
            mstore(0, IC1x_0)
            mstore(32, IC1x_1)
            mstore(64, IC1y_0)
            mstore(96, IC1y_1)
            tmp := calldataload(add(o, 512))
            checkField(tmp)
            mstore(128, tmp)
            
            // vk
            let success := staticcall(sub(gas(), 2000), G1_MSM_PRECOMPILE, 0, 320, 0, 128)
            if iszero(success) {
                mstore(0, ERROR_G1_MSM_FAILED)
                revert(0, 0x04)
            }

            mstore(128, IC0x_0)
            mstore(160, IC0x_1)
            mstore(192, IC0y_0)
            mstore(224, IC0y_1)
            // add IC0 to the result of the MSM
            success := staticcall(sub(gas(), 2000), G1_ADD_PRECOMPILE, 0, 256, 0, 128)
            // in practice this error should never happen, only if the precompile is broken
            if iszero(success) {
                mstore(0, ERROR_G1_ADD_FAILED)
                revert(0, 0x04)
            }

            // https://www.zeroknowledgeblog.com/index.php/groth16
            // e(vk, gamma) * e(C, delta) * e(alpha, beta) * e(-A, B) == 1

            // gamma
            mstore(128, gammax1_0)
            mstore(160, gammax1_1)
            mstore(192, gammay1_0)
            mstore(224, gammay1_1)
            mstore(256, gammax2_0)
            mstore(288, gammax2_1)
            mstore(320, gammay2_0)
            mstore(352, gammay2_1)
            // C
            calldatacopy(384, add(o, 384), 128)
            // delta
            mstore(512, deltax1_0)
            mstore(544, deltax1_1)
            mstore(576, deltay1_0)
            mstore(608, deltay1_1)
            mstore(640, deltax2_0)
            mstore(672, deltax2_1)
            mstore(704, deltay2_0)
            mstore(736, deltay2_1)
            // alpha
            mstore(768, alphax_0)
            mstore(800, alphax_1)
            mstore(832, alphay_0)
            mstore(864, alphay_1)
            // beta
            mstore(896, betax1_0)
            mstore(928, betax1_1)
            mstore(960, betay1_0)
            mstore(992, betay1_1)
            mstore(1024, betax2_0)
            mstore(1056, betax2_1)
            mstore(1088, betay2_0)
            mstore(1120, betay2_1)
            // e(-A, B)
            calldatacopy(1152, o, 384)

            // result of pairing check is saved to offset 0
            success := staticcall(sub(gas(), 2000), PAIRING_PRECOMPILE, 0, 1536, 0, 32)
            if iszero(success) {
                mstore(0, ERROR_PAIRING_FAILED)
                revert(0, 0x04)
            }

            return(0, 0x20)
        }
    }
 }