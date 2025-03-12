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
    bytes32 constant alphax_0  = 0x000000000000000000000000000000000f58323a93c517afe0dbb93b5b3db309;
    bytes32 constant alphax_1  = 0xb9b641b7056fd14f87987293fe2b7c7671aed23638bfacfd41bd49d190a068ef;
    bytes32 constant alphay_0  = 0x0000000000000000000000000000000003f84652dc9a9cccf9abe2a577b8884d;
    bytes32 constant alphay_1  = 0x2b0bab9cbe075633630f0ff8f763e270ac32479b0967af026e89e71e25e9a882;
    
    bytes32 constant betax1_0  = 0x000000000000000000000000000000000a2dc4ec42e832824d068834086d1692;
    bytes32 constant betax1_1  = 0x912e647dd0d82595a30deff528f98c17a59802fe2ff88593920f298b0eb1490b;
    bytes32 constant betay1_0  = 0x00000000000000000000000000000000056c76173acbcaa2e5d0cdfe1eee5b23;
    bytes32 constant betay1_1  = 0xd8f169dda6f9a426be2ca041af54ea397dc1b74529e90f6c79141c3288fd9bf2;
    bytes32 constant betax2_0  = 0x0000000000000000000000000000000008456842198fe0a5544d10fa2247c8db;
    bytes32 constant betax2_1  = 0xc7c5722722981e74f146860957d161903f06f6ef4e60cb90983f37ba4f888a15;
    bytes32 constant betay2_0  = 0x000000000000000000000000000000000dadf33cd97b70cf9db1594d3892c705;
    bytes32 constant betay2_1  = 0x26c6640df2fd4f227e21bb56c851779279b79b11993cb8d2f16cf074de56deed;

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
    bytes32 constant IC0x_0 = 0x0000000000000000000000000000000005107a2acbd409bb09513b7a83d0c6b1;
    bytes32 constant IC0x_1 = 0xc01d528f07c55c5a47b276b3c6df0b5e812927fcb01e7fd3e9a9663b68f3c7d0;
    bytes32 constant IC0y_0 = 0x000000000000000000000000000000000c5beb467829d8c27eec670976b7d392;
    bytes32 constant IC0y_1 = 0x43cb8537719120eeb743a962f4f3a752614f372a90bfa8c0e3fdf70fb208c96a;
    bytes32 constant IC1x_0 = 0x0000000000000000000000000000000001a5ef7fe21f48d5f3677f45de2fdce1;
    bytes32 constant IC1x_1 = 0xac94bd836f74d82a58efa58908e930fa4dbb77788f03e32da7f3f036b3c76e2a;
    bytes32 constant IC1y_0 = 0x000000000000000000000000000000000675ad2922bde59f673a244ada6c3846;
    bytes32 constant IC1y_1 = 0x6de1af493a8ef3dc04fc624f8db59deeff42514577e95dc67e5c526973017bb6;

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
 
    function verifyProof(bytes calldata proof) public view returns (bool){
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
            // TODO: optimize by not including IC0 in the MSM (since every point multiplied by 1 is itself)
            let success := staticcall(sub(gas(), 2000), G1_MSM_PRECOMPILE, 0, 320, 0, 128)
            if iszero(success) {
                mstore(0, 0)
                return(0, 0x20)
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
                mstore(0, 0)
                return(0, 0x20)
            }

            return(0, 0x20)
        }
    }
 }