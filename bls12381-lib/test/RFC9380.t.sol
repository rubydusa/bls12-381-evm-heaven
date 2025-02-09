// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {console, Test} from "forge-std/Test.sol";
import {RFC9380} from "@src/BLS12381Lib.sol";

interface IRFC9380Types {
    struct ExpandMessageXMDTestVector {
        string message;
        uint16 len_in_bytes;
        bytes uniform_bytes;
    }
}

abstract contract ExpandMessageXMDTestVectors is IRFC9380Types {
    string internal constant XMD_DST = "QUUX-V01-CS02-with-expander-SHA256-128";

    function expandMessageXMDTestVectors() internal pure returns (ExpandMessageXMDTestVector[] memory vectors) {
        vectors = new ExpandMessageXMDTestVector[](10);
        vectors[0] = ExpandMessageXMDTestVector({
            message: "",
            len_in_bytes: 0x20,
            uniform_bytes: hex"68a985b87eb6b46952128911f2a4412bbc302a9d759667f87f7a21d803f07235"
        });
        vectors[1] = ExpandMessageXMDTestVector({
            message: "abc",
            len_in_bytes: 0x20,
            uniform_bytes: hex"d8ccab23b5985ccea865c6c97b6e5b8350e794e603b4b97902f53a8a0d605615"
        });
        vectors[2] = ExpandMessageXMDTestVector({
            message: "abcdef0123456789",
            len_in_bytes: 0x20,
            uniform_bytes: hex"eff31487c770a893cfb36f912fbfcbff40d5661771ca4b2cb4eafe524333f5c1"
        });
        vectors[3] = ExpandMessageXMDTestVector({
            message: "q128_qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
            len_in_bytes: 0x20,
            uniform_bytes: hex"b23a1d2b4d97b2ef7785562a7e8bac7eed54ed6e97e29aa51bfe3f12ddad1ff9"
        });
        vectors[4] = ExpandMessageXMDTestVector({
            message: "a512_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            len_in_bytes: 0x20,
            uniform_bytes: hex"4623227bcc01293b8c130bf771da8c298dede7383243dc0993d2d94823958c4c"
        });
        vectors[5] = ExpandMessageXMDTestVector({
            message: "",
            len_in_bytes: 0x80,
            uniform_bytes: hex"af84c27ccfd45d41914fdff5df25293e221afc53d8ad2ac06d5e3e29485dadbee0d121587713a3e0dd4d5e69e93eb7cd4f5df4cd103e188cf60cb02edc3edf18eda8576c412b18ffb658e3dd6ec849469b979d444cf7b26911a08e63cf31f9dcc541708d3491184472c2c29bb749d4286b004ceb5ee6b9a7fa5b646c993f0ced"
        });
        vectors[6] = ExpandMessageXMDTestVector({
            message: "abc",
            len_in_bytes: 0x80,
            uniform_bytes: hex"abba86a6129e366fc877aab32fc4ffc70120d8996c88aee2fe4b32d6c7b6437a647e6c3163d40b76a73cf6a5674ef1d890f95b664ee0afa5359a5c4e07985635bbecbac65d747d3d2da7ec2b8221b17b0ca9dc8a1ac1c07ea6a1e60583e2cb00058e77b7b72a298425cd1b941ad4ec65e8afc50303a22c0f99b0509b4c895f40"
        });
        vectors[7] = ExpandMessageXMDTestVector({
            message: "abcdef0123456789",
            len_in_bytes: 0x80,
            uniform_bytes: hex"ef904a29bffc4cf9ee82832451c946ac3c8f8058ae97d8d629831a74c6572bd9ebd0df635cd1f208e2038e760c4994984ce73f0d55ea9f22af83ba4734569d4bc95e18350f740c07eef653cbb9f87910d833751825f0ebefa1abe5420bb52be14cf489b37fe1a72f7de2d10be453b2c9d9eb20c7e3f6edc5a60629178d9478df"
        });
        vectors[8] = ExpandMessageXMDTestVector({
            message: "q128_qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
            len_in_bytes: 0x80,
            uniform_bytes: hex"80be107d0884f0d881bb460322f0443d38bd222db8bd0b0a5312a6fedb49c1bbd88fd75d8b9a09486c60123dfa1d73c1cc3169761b17476d3c6b7cbbd727acd0e2c942f4dd96ae3da5de368d26b32286e32de7e5a8cb2949f866a0b80c58116b29fa7fabb3ea7d520ee603e0c25bcaf0b9a5e92ec6a1fe4e0391d1cdbce8c68a"
        });
        vectors[9] = ExpandMessageXMDTestVector({
            message: "a512_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            len_in_bytes: 0x80,
            uniform_bytes: hex"546aff5444b5b79aa6148bd81728704c32decb73a3ba76e9e75885cad9def1d06d6792f8a7d12794e90efed817d96920d728896a4510864370c207f99bd4a608ea121700ef01ed879745ee3e4ceef777eda6d9e5e38b90c86ea6fb0b36504ba4a45d22e86f6db5dd43d98a294bebb9125d5b794e9d2a81181066eb954966a487"
        });
    }
}

contract RFC9380Test is Test, ExpandMessageXMDTestVectors {
    function test_hash_to_curve_g1() public pure {
        // TODO: implement
        // https://www.rfc-editor.org/rfc/rfc9380.html#name-bls12381g1_xmdsha-256_sswu_
    }

    function test_hash_to_field() public pure {
        // TODO: implement
        // Could not find any test vectors for this
    }

    // failing test vectors: 3, 4, 5, 6, 9, 10
    // TODO: fix, all of these have long messages so something gets fucked up in the encoding
    function test_expand_message_xmd() public pure {
        // https://www.rfc-editor.org/rfc/rfc9380.html#name-expand-test-vectors
        ExpandMessageXMDTestVector[] memory vectors = expandMessageXMDTestVectors();
        for (uint256 i = 0; i < vectors.length; i++) {
            ExpandMessageXMDTestVector memory vector = vectors[i];
            bytes memory result = RFC9380.expandMessageXMD(bytes(vector.message), XMD_DST, vector.len_in_bytes);
            assertEq(result, vector.uniform_bytes);
        }
    }
}
