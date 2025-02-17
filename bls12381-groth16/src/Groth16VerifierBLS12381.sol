// TODO: convert to template
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

// I'm tormeneted, when EOF already :((
// no idea what's the preferable way to represent verification key and proof data
// TODO: instead of returning nothing, return error selectors
contract Groth16Verifier {
    // precompiles
    uint256 constant G1_MSM_PRECOMPILE = 12;
    uint256 constant PAIRING_PRECOMPILE = 15;
    // Main subgroup order
    uint256 constant q = 0x73eda753299d7d483339d80809a1d80553bda402fffe5bfeffffffff00000001;

    // Verification Key data
    bytes32 constant alphax_0  = 0x0;
    bytes32 constant alphax_1  = 0x0;
    bytes32 constant alphay_0  = 0x0;
    bytes32 constant alphay_1  = 0x0;
    bytes32 constant betax1_0  = 0x0;
    bytes32 constant betax1_1  = 0x0;
    bytes32 constant betax2_0  = 0x0;
    bytes32 constant betax2_1  = 0x0;
    bytes32 constant betay1_0  = 0x0;
    bytes32 constant betay1_1  = 0x0;
    bytes32 constant betay2_0  = 0x0;
    bytes32 constant betay2_1  = 0x0;
    bytes32 constant gammax1_0 = 0x0;
    bytes32 constant gammax1_1 = 0x0;
    bytes32 constant gammax2_0 = 0x0;
    bytes32 constant gammax2_1 = 0x0;
    bytes32 constant gammay1_0 = 0x0;
    bytes32 constant gammay1_1 = 0x0;
    bytes32 constant gammay2_0 = 0x0;
    bytes32 constant gammay2_1 = 0x0;
    bytes32 constant deltax1_0 = 0x0;
    bytes32 constant deltax1_1 = 0x0;
    bytes32 constant deltax2_0 = 0x0;
    bytes32 constant deltax2_1 = 0x0;
    bytes32 constant deltay1_0 = 0x0;
    bytes32 constant deltay1_1 = 0x0;
    bytes32 constant deltay2_0 = 0x0;
    bytes32 constant deltay2_1 = 0x0;

    uint256 constant nPublic = 2;
    bytes32 constant IC0x_0 = 0x0;
    bytes32 constant IC0x_1 = 0x0;
    bytes32 constant IC0y_0 = 0x0;
    bytes32 constant IC0y_1 = 0x0;
    bytes32 constant IC1x_0 = 0x0;
    bytes32 constant IC1x_1 = 0x0;
    bytes32 constant IC1y_0 = 0x0;
    bytes32 constant IC1y_1 = 0x0;

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
 
    function verifyProof(bytes calldata proof) public view returns (bool isValid){
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
            mstore(32, IC0y_0)
            mstore(64, IC1x_0)
            mstore(96, IC1y_0)
            calldatacopy(128, add(o, 512), 32)
            mstore(160, IC0x_1)
            mstore(192, IC0y_1)
            mstore(224, IC1x_1)
            mstore(256, IC1y_1)
            calldatacopy(288, add(o, 544), 32)
            // vk
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
            calldatacopy(384, add(0, 384), 128)
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