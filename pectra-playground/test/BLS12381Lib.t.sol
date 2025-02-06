// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import {Test} from "forge-std/Test.sol";
import {BLS12381Lib, IBLSTypes} from "@src/BLS12381Lib.sol";

contract BLS12381LibTest is Test, IBLSTypes {
    using BLS12381Lib for G1Point;
    using BLS12381Lib for G2Point;
    function test_mulBaseG1_identity() public view {
        G1Point result = BLS12381Lib.mulBaseG1(1);
        assertEq(result.asBytes(), BLS12381Lib.G1_GENERATOR);
    }

    function test_mulBaseG1_zero() public view {
        G1Point zeroResult = BLS12381Lib.mulBaseG1(0);
        bytes memory infinity = new bytes(128);
        assertEq(zeroResult.asBytes(), infinity);
    }

    function test_mulBaseG1_scalar() public view {
        G1Point point = BLS12381Lib.mulBaseG1(123456789);
        assertEq(point.asBytes(), hex"000000000000000000000000000000000f95b8218cbee2f4fa48e6b6f1df4e8ee46fee73c270dba395dad523d10c9b35295ccfc92cf0a9db8a065e16dafbfaad00000000000000000000000000000000198a99c756b5a6e9f5917aa7c3e7f6191a38b1f0f348f6be14a15814c15ce2417ade0a03dc5595abac997da5f5fc5338");
    }

    function test_mulBaseG2_identity() public view {
        G2Point result = BLS12381Lib.mulBaseG2(1);
        assertEq(result.asBytes(), BLS12381Lib.G2_GENERATOR);
    }

    function test_mulBaseG2_zero() public view {
        G2Point zeroResult = BLS12381Lib.mulBaseG2(0);
        bytes memory infinity = new bytes(256);
        assertEq(zeroResult.asBytes(), infinity);
    }

    function test_mulBaseG2_scalar() public view {
        G2Point point = BLS12381Lib.mulBaseG2(123456789);
        assertEq(point.asBytes(), hex"000000000000000000000000000000001380055ab9f1a87786f2508f3e4ce5caa5abcdae0a80141ee8ccc3626311e0a53be5d873fa964fd85ad56771f2984579000000000000000000000000000000001068ad1be382009ac2dce123ec62dca8337d6b93b909b3ee52e31cb9e4098d1b56d596bf3c08166c7b46cb3aa85c2338000000000000000000000000000000000ee5d679615b0ac8fc39d0bd398990abaac87641757a24839edf8ccfc9e7d839d5a45c5afde88a129ac38a63b9c6cf6600000000000000000000000000000000160526992769b742b3d31b06a77b3a2eb84c1700c0efdf03e1ccb34954e97050471f22b54b4de9e933ff040cde20422a");
    }
}
