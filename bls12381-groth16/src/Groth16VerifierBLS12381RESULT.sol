// SPDX-License-Identifier: GPL-3.0
//----------------------------------------------------------------------------//
//                                                                            //
//  This file is a modified version of the original groth16 verifier template //
//  from https://github.com/iden3/snarkjs                                     //
//                                                                            //
//----------------------------------------------------------------------------//
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

// TODO: instead of returning nothing, return error selectors
contract Groth16Verifier {
    // precompiles
    uint256 constant G1_MSM_PRECOMPILE = 12;
    uint256 constant PAIRING_PRECOMPILE = 15;
    // Main subgroup order
    uint256 constant q = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;

    // Verification Key data
    bytes32 constant alphax_0  = 0x000000000000000000000000000000000f4ee38de586fb5ba0e86131419b393a;
    bytes32 constant alphax_1  = 0xe3da9c9b1764c687d487237c3bcaea52d483e9f5740a9741d0e6eacd7359468c;
    bytes32 constant alphay_0  = 0x0000000000000000000000000000000007d1855f92766e2416ced2729f63ae3a;
    bytes32 constant alphay_1  = 0x09ae2d3c3b1a41629bb4ca23148bf9d5ce7eecbc009671b7b84849dc09469860;
    
    bytes32 constant betax1_0  = 0x00000000000000000000000000000000034af43e7f4888d49c2c72fa9569c21c;
    bytes32 constant betax1_1  = 0xe01f4ab81eb53fdb888b70ebeba4ebd832e8f50c3cf8be7dddb9ff4ee49bd9ba;
    bytes32 constant betay1_0  = 0x000000000000000000000000000000000bc41734b3495478d79fe18e72602836;
    bytes32 constant betay1_1  = 0x495d1ec6696e9545173d4605bf585fea10022a0e3df8d3f23f655514b51b51bb;
    bytes32 constant betax2_0  = 0x000000000000000000000000000000000e6134b38fbff6bcb0e3f50205d4c327;
    bytes32 constant betax2_1  = 0xc8ceab463b8e630d2028e49f7fda26056370ab72b35ef1b2fa68de1c6dddfb2b;
    bytes32 constant betay2_0  = 0x000000000000000000000000000000000d3faf483b877604007903f5e8c9e121;
    bytes32 constant betay2_1  = 0xe6e764d35ddea6334ba21aed110301bc6ea2cc13dbb1e4132ea68ffcf7ec34fb;

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
    bytes32 constant IC0x_0 = 0x0000000000000000000000000000000017701d942833d4676e6722b005a67116;
    bytes32 constant IC0x_1 = 0x9f4168d43cc1e30554338f117feb466c950009a349a6d0575ba4f96701a2ffa5;
    bytes32 constant IC0y_0 = 0x000000000000000000000000000000000c50be4aa05a2a5d7f8e103ceed67161;
    bytes32 constant IC0y_1 = 0x3f4fce322875fcc97963a80c62ef08c63a341fa091626ad188cd76eb9fb8fb26;
    bytes32 constant IC1x_0 = 0x000000000000000000000000000000000ad098472ca0878240398852abde8262;
    bytes32 constant IC1x_1 = 0xc4913113c7ec55461e1017d7777245f4bb4632c9ea2a3c387ac177f0808a2c69;
    bytes32 constant IC1y_0 = 0x0000000000000000000000000000000009912644f1e61297f23535750aa3af11;
    bytes32 constant IC1y_1 = 0x84b54326bf1ad0e6e8f354f602080a7665bcd2a0a59debe56fe293e6efa3491d;

    // proof structure:
    // negA: 128 bytes
    // B: 256 bytes
    // C: 128 bytes
    // pubSignals: 32 * nPublic bytes
    uint256 immutable proofLength;

    // avoid computing in runtime
    // TODO: could theoretically be precomputed in template, should it be?
    constructor () {
        proofLength = 512 + 32 * nPublic;
    }
 
    function verifyProof(bytes calldata proof) public view returns (bool isValid) {
        // assembly does not support immutable variables
        uint256 _proofLength = proofLength;
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            // check proof length
            if iszero(eq(proof.length, _proofLength)) {
                mstore(0, 0)
                return(0, 0x20)
            }

            let o := proof.offset
            // msm of pub signals
            mstore(0, IC0x_0)
            mstore(32, IC0x_1)
            mstore(64, IC0y_0)
            mstore(96, IC0y_1)
            calldatacopy(128, add(o, 512), 32)
            mstore(160, IC1x_0)
            mstore(192, IC1x_1)
            mstore(224, IC1y_0)
            mstore(256, IC1y_1)
            calldatacopy(288, add(o, 544), 32)
            // vk
            let success := staticcall(sub(gas(), 2000), G1_MSM_PRECOMPILE, 0, 320, 0, 128)
            if iszero(success) {
                mstore(0, 0)
                return(0, 0x20)
            }
            // mstore(0, 0)
            // return(0, 0x20)

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
                mstore(0, 0)
                return(0, 0x20)
            }

            isValid := mload(0)
        }
    }
 }