
// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;

import {Test, console} from "forge-std/Test.sol";
import {Groth16Verifier} from "../src/Groth16VerifierBLS12381_2.sol";
import {IGroth16VerifierBLS12381Errors} from "../src/interfaces/IGroth16VerifierBLS12381.sol";

// proof structure:
// negA: 128 bytes
// B: 256 bytes
// C: 128 bytes
// pubSignals: 32 * nPublic bytes
contract Groth16VerifierTest_2 is Test, IGroth16VerifierBLS12381Errors {
    address constant G1MSM_PRECOMPILE = address(12);

    bytes constant _calldata = hex"00000000000000000000000000000000077b91a7b280fe254b2be272030b9c6c0b10d9716b455c47b6e6b7cc5fa67b499d88d12ee00d1794bd0941c334a7db2100000000000000000000000000000000117d4dcd537577e5132c96950e7d510cbf3ede8257f16f6c467869e62247a7feb08caa01492470162d5e11eef103048b0000000000000000000000000000000011379e4e157ed1c33d65926851e9b9737dcb93dd99201714611812f3dbec27091566bab9c073bdac9fb106374811e73500000000000000000000000000000000009501e55b58dddaa682e64a8036181a70e8807837f428300f04968fc53d1c0da4a8c673c4c0143b5689ff8131ed106000000000000000000000000000000000058a051573109fb3e6a988645177eb1d4d495edd184b6ddd04e8da0413b9bfcf84946252d201fd6a4c3b16281cbc3da30000000000000000000000000000000000579ce461b1d0c1fb0128f93ab4b0a907aa3dbb2e7e706a7c42b286e8000b64651f1e3ff1d29a2d50ce539822ab806800000000000000000000000000000000003c0ffd68c80bed848e4b0d65b9af03e3d3235ce1437921a33e25215a349100c927b1e9621157296f92c5723e9e2796000000000000000000000000000000000c639a170c9ddd251b3414b61ac4b7610b283e8448d70fcfa55a45359ef0a78bc2a3b91d9a3b8f2fd05e499fcd8fa83400000000000000000000000000000000000000000000000000000000000000010000000000000000000000000000000000000000000000000000000000000008";
    Groth16Verifier verifier;

    function setUp() public {
        verifier = new Groth16Verifier();
    }

    function test_verifyProof_proofVerified() public {
        bool result = verifier.verifyProof(_calldata);
        assertTrue(result);
    }

    function test_verifyProof_proofRejected() public {
        // change negA to a different point
        bytes memory _calldataMalformed = _calldata;
        // I copied the point values from IC0
        bytes32 x0 = 0x00000000000000000000000000000000108bdd826e61d0dc272113949a7a07b3;
        bytes32 x1 = 0x58bbeca079169bb14b1218fb8d642518b13f046ab57c707af55850c7f115cef0;
        bytes32 y0 = 0x0000000000000000000000000000000001718794d32ab142286ff7bee3d44df9;
        bytes32 y1 = 0xb864029b13c97679f36d4b1903b8d382cc137932176c1d4b51eef88a3413af7b;
        assembly {
            mstore(add(_calldataMalformed, 0x20), x0)
            mstore(add(_calldataMalformed, 0x40), x1)
            mstore(add(_calldataMalformed, 0x60), y0)
            mstore(add(_calldataMalformed, 0x80), y1)
        }
        bool result = verifier.verifyProof(_calldataMalformed);
        assertFalse(result);
    }

    function testVerify_verifyProof_revert_NotInField() public {
        bytes memory _calldataMalformed = _calldata;
        uint256 invalidScalar = type(uint256).max;
        assembly { 
            mstore(add(_calldataMalformed, 544), invalidScalar) 
        }
        vm.expectRevert(abi.encodeWithSelector(NotInField.selector, invalidScalar));
        verifier.verifyProof(_calldataMalformed);
    }

    function testVerify_verifyProof_revert_InvalidProofLength() public {
        bytes memory _calldataMalformed = _calldata;
        assembly {
            mstore(_calldataMalformed, 1234)
        }
        vm.expectRevert(abi.encodeWithSelector(InvalidProofLength.selector));
        verifier.verifyProof(_calldataMalformed);
    }

    // Should not happen unless a chain has a conflicting precompile at G1MSM's precompile address
    function testVerify_verifyProof_revert_G1MSMFailed() public {
        bytes memory empty;
        vm.mockCallRevert(G1MSM_PRECOMPILE, empty, empty);
        vm.expectRevert(abi.encodeWithSelector(G1MSMFailed.selector));
        verifier.verifyProof(_calldata);
    }

    // This pairing failed is on the basis of an invalid curve point
    function testVerify_verifyProof_revert_PairingFailed() public {
        bytes memory _calldataMalformed = _calldata;
        // invalidate x coordinate of negA
        assembly {
            mstore(add(_calldataMalformed, 0x20), 0)
        }
        vm.expectRevert(abi.encodeWithSelector(PairingFailed.selector));
        verifier.verifyProof(_calldataMalformed);
    }
}
