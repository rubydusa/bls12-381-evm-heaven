
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
    address constant G1ADD_PRECOMPILE = address(11);
    address constant G1MSM_PRECOMPILE = address(12);

    bytes constant _calldata = hex"0000000000000000000000000000000014bffc707a7a558910347433d31e986a34283ce3d25aedff7a5fc43853086d4077d8997224e77141fe0a5adfabccc519000000000000000000000000000000001117af7307c9bc41957ab426ff0d17ab9ba9d5b44b5f9bc1e557c60d8c28bee65821d7cb37c692944540765519f36ff800000000000000000000000000000000170208334bcfc047ce577c4f9acfdfa30376700864920e45bc42ef6262d8738e4128bc7d503af12e24a642d22031306500000000000000000000000000000000024ef824cf055b04c7a98bce61bf3a7e02e66b2fbf3e30a2dc0351c8349ca7cfd7abc903dca2b614ee22f27c267e8ecd00000000000000000000000000000000155fd6a3360a18b71dbbe8d5da31bb1aff10efd21b607887f205587cbd2fbd09654f8a2c0ec253e34ab30cb9a32193950000000000000000000000000000000004917150e859bdc670008d4a33097607d4b5e9c36fde9d4961357a6e407575806cda76d836a90c678b65b5463d1cb26a0000000000000000000000000000000001eb1210f8b713096fa0a8749850e3bb1f5178ea6ba26f6bd5b83c21d5451e48181bb2f753ff2c05dfc717b7065632f900000000000000000000000000000000159a7c4cd0fdc64d105d4499e9b35797f7a423c547d98497a1764a50202b9500ee52d23b5939681131a022bba8b05b1a0000000000000000000000000000000000000000000000000000000000000008";
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

    function test_verifyProof_revert_NotInField() public {
        bytes memory _calldataMalformed = _calldata;
        uint256 invalidScalar = type(uint256).max;
        assembly { 
            mstore(add(_calldataMalformed, 544), invalidScalar) 
        }
        vm.expectRevert(abi.encodeWithSelector(NotInField.selector, invalidScalar));
        verifier.verifyProof(_calldataMalformed);
    }

    function test_verifyProof_revert_InvalidProofLength() public {
        bytes memory _calldataMalformed = _calldata;
        assembly {
            mstore(_calldataMalformed, 1234)
        }
        vm.expectRevert(abi.encodeWithSelector(InvalidProofLength.selector));
        verifier.verifyProof(_calldataMalformed);
    }

    // Should not happen unless a chain has a conflicting precompile at G1MSM's precompile address
    function test_verifyProof_revert_G1MSMFailed() public {
        bytes memory empty;
        vm.mockCallRevert(G1MSM_PRECOMPILE, empty, empty);
        vm.expectRevert(abi.encodeWithSelector(G1MSMFailed.selector));
        verifier.verifyProof(_calldata);
    }

    // Should not happen unless a chain has a conflicting precompile at G1ADD's precompile address
    function test_verifyProof_revert_G1AddFailed() public {
        bytes memory empty;
        vm.mockCallRevert(G1ADD_PRECOMPILE, empty, empty);
        vm.expectRevert(abi.encodeWithSelector(G1AddFailed.selector));
        verifier.verifyProof(_calldata);
    }

    // This pairing failed is on the basis of an invalid curve point
    function test_verifyProof_revert_PairingFailed() public {
        bytes memory _calldataMalformed = _calldata;
        // invalidate x coordinate of negA
        assembly {
            mstore(add(_calldataMalformed, 0x20), 0)
        }
        vm.expectRevert(abi.encodeWithSelector(PairingFailed.selector));
        verifier.verifyProof(_calldataMalformed);
    }
}
