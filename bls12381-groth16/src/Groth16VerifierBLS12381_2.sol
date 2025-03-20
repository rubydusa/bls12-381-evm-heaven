// SPDX-License-Identifier: GPL-3.0
// Author: Rubydusa 2025

pragma solidity >=0.7.0 <0.9.0;

contract Groth16Verifier {
    // precompiles
    uint256 constant G1_MSM_PRECOMPILE = 12;
    uint256 constant PAIRING_PRECOMPILE = 15;
    // Main subgroup order
    uint256 constant q = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;

    // Verification Key data
    bytes32 constant alphax_0  = 0x00000000000000000000000000000000184a14743a1629d3eff3082d0a11de70;
    bytes32 constant alphax_1  = 0x19c414ce124b23ec650e5a5be2d5eb0cb8383664bef87170d3fa990a7fb10d45;
    bytes32 constant alphay_0  = 0x000000000000000000000000000000001406bd99aa424a9452ae69635c0f29bd;
    bytes32 constant alphay_1  = 0xa13a340b16e5b1f3cea3a940a5f352a4c61e5ba5bf79de10eff785646c6f0f0c;
    
    bytes32 constant betax1_0  = 0x000000000000000000000000000000000e0c5326948f6ee76bee4a763dc4087b;
    bytes32 constant betax1_1  = 0x0a84e8b1296a6801e2ad9e56e1c6c3e707f8dd21900418fe41d9b7599715e02d;
    bytes32 constant betay1_0  = 0x000000000000000000000000000000000392603339271dfd8b88b7db53f2f0f3;
    bytes32 constant betay1_1  = 0xdf9e1ccfe2e4adb6618072d441ee795ec7baae792e0511162c491e7d106e4985;
    bytes32 constant betax2_0  = 0x00000000000000000000000000000000193e7a6214bb94f8a07af038a1935ef0;
    bytes32 constant betax2_1  = 0xa3551460661b56a7d40cdf49e6d4dada4ffef138ff51bc63d643ff5a599a0f97;
    bytes32 constant betay2_0  = 0x000000000000000000000000000000000c9ac932295e01c5bf28f9a2866086d8;
    bytes32 constant betay2_1  = 0x6cfb1fdbe3c677ba783bb2de47b2627ab2ac807e4352adabe4f8a07370c36bc8;

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

    uint256 constant nPublic = 2;
    uint256 constant proofLength = 576;
    
    bytes32 constant IC0x_0 = 0x000000000000000000000000000000000afa7d06b3d28b5ad4d39929c0b0f0b0;
    bytes32 constant IC0x_1 = 0xa9b29351efdb29cd0580dc1940bc1b60ffe48937e376b1a19786b64f3c9aef74;
    bytes32 constant IC0y_0 = 0x00000000000000000000000000000000028c314866271f3292e066b570f47734;
    bytes32 constant IC0y_1 = 0xdd6fa74a0ababeb047822a0aefa40037db581c88ed242fa85193a7a0e9ca9e8a;
    
    bytes32 constant IC1x_0 = 0x0000000000000000000000000000000010236d6d920490d405fc732482f94b03;
    bytes32 constant IC1x_1 = 0xd063e9a75344a8a91eb7d0f8a0d4d6a713eb292068523289342bbbf35eecb797;
    bytes32 constant IC1y_0 = 0x000000000000000000000000000000000ad88a3f9cda5a51fac7126241ee0a1c;
    bytes32 constant IC1y_1 = 0xc3d3d81bc9c6a053594ca877a1c52ac4ed249f6e0faedef858a13db1a2875d37;
    

    bytes4 constant ERROR_NOT_IN_FIELD = 0x81452424;  // cast sig "NotInField(uint256)"
    bytes4 constant ERROR_INVALID_PROOF_LENGTH = 0x4dc5f6a4;  // cast sig "InvalidProofLength()"
    bytes4 constant ERROR_G1_MSM_FAILED = 0x5f776986;  // cast sig "G1MSMFailed()"
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
            // msm of pub signals
            
            mstore(0, IC0x_0)
            mstore(32, IC0x_1)
            mstore(64, IC0y_0)
            mstore(96, IC0y_1)
            tmp := calldataload(add(o, 512))
            checkField(tmp)
            mstore(128, tmp)
            
            mstore(160, IC1x_0)
            mstore(192, IC1x_1)
            mstore(224, IC1y_0)
            mstore(256, IC1y_1)
            tmp := calldataload(add(o, 544))
            checkField(tmp)
            mstore(288, tmp)
            
            // vk
            // TODO: optimize by not including IC0 in the MSM (since every point multiplied by 1 is itself)
            let success := staticcall(sub(gas(), 2000), G1_MSM_PRECOMPILE, 0, 320, 0, 128)
            if iszero(success) {
                mstore(0, ERROR_G1_MSM_FAILED)
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