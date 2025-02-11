// SPDX-License-Identifier: MIT
pragma solidity ^0.8.16;

import {console, Test} from "forge-std/Test.sol";
import {RFC9380, BLS12381Lib, IBLSTypes} from "@src/BLS12381Lib.sol";

interface IRFC9380Types {
    struct ExpandMessageXMDTestVector {
        string message;
        uint16 len_in_bytes;
        bytes uniform_bytes;
    }

    struct HashToFieldTestVector {
        string message;
        bytes[] elements;
    }

    struct HashToG1TestVector {
        string message;
        bytes px;
        bytes py;
    }
}

abstract contract BaseTestVectors is IRFC9380Types {
    function __fix(bytes memory element) internal pure returns (bytes memory) {
        return __pad64(element);
    }

    function __fix(string[1] memory elements) internal pure returns (bytes[] memory) {
        bytes[] memory elementsFixed = new bytes[](1);
        elementsFixed[0] = __pad64(bytes(elements[0]));
        return elementsFixed;
    }

    function __fix(string[2] memory elements) internal pure returns (bytes[] memory) {
        bytes[] memory elementsFixed = new bytes[](2);
        elementsFixed[0] = __pad64(bytes(elements[0]));
        elementsFixed[1] = __pad64(bytes(elements[1]));
        return elementsFixed;
    }

    function __pad64(bytes memory element) internal pure returns (bytes memory) {
        uint256 length = element.length;
        uint256 pad = 64 - length;
        bytes memory padded = new bytes(64);
        assembly {
            mcopy(add(add(padded, 0x20), pad), add(element, 0x20), length)
        }
        return padded;
    }
}

abstract contract ExpandMessageXMDTestVectors is BaseTestVectors {
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

/// @notice HashToField test vectors are not part of the RFC9380 spec, test vectors were generated specifically for SHA256 g1
/// @dev https://github.com/rubydusa/draft-irtf-cfrg-hash-to-curve
/// @dev https://github.com/rubydusa/draft-irtf-cfrg-hash-to-curve/blob/6c3a6a264123477a8bafd7d3289b9534fcd1f31b/poc/vectors/hash_to_field_expanderSHA256_128_fp.json
abstract contract HashToFieldTestVectors is BaseTestVectors {
    /// @dev using the same dst as for the expander test vectors
    string internal constant HASH_TO_FIELD_DST = "QUUX-V01-CS02-with-expander-SHA256-128";

    function hashToFieldTestVectors() internal pure returns (HashToFieldTestVector[] memory vectors) {
        vectors = new HashToFieldTestVector[](10);
        vectors[0] = HashToFieldTestVector({
            message: "",
            elements: __fix([hex"0cbd374d40a9291b22d1924fd653ee1835da25d3d8829c6721e651d8b1b2eea7de9cf8c176062a1f5b306c858213a680"])
        });
        vectors[1] = HashToFieldTestVector({
            message: "",
            elements: __fix([hex"01aacb6f986c447f74d856522a91f55e6a50d32f2d5eb6cd41d9fdcaa78cf6f2441407ddf22391ee5d7244b3599e70a7",
            hex"16e3f793af811480640340a4776a54c7c86be29f182662603ab73f4c8042ba60eed2b9b14980792b65af9436269a71b3"])
        });
        vectors[2] = HashToFieldTestVector({
            message: "abc",
            elements: __fix([hex"06c9df9d8c1eed18d597ef39a5a3f3578c5146aa9a454a54b9157e45570baaa58d6ea34f7fec3c1a849e11a586471e3a"])
        });
        vectors[3] = HashToFieldTestVector({
            message: "abc",
            elements: __fix([hex"0cc90c571277f8f08a9100a16b7e41f9cc66e66399cccee4c961844e2702db67493740cf5135be15ff6464db11c670c0", hex"03bb970213f1fa688aa4539d57fa570794d1940d8119ae760fb9179087170f1bd1e6677472ea10a5b8796e2a9c71154f"])
        });
        vectors[4] = HashToFieldTestVector({
            message: "abcdef0123456789",
            elements: __fix([hex"1789c13bcbc00bf22eeb6e017ccc0792686bb75c879438b2bb606614b06274c1f275ebaa79d87ab0f8f4590eec7c44dc"])
        });
        vectors[5] = HashToFieldTestVector({
            message: "abcdef0123456789",
            elements: __fix([hex"036b840e26d29e3dae33509d54bbc0954110bb098a921fdd256e675a24a94902918c858c2a246d49efd9d748d58bc65c", hex"0eeb61950fd1701d03921aac67f028bcdec9f9d55e12f70eb35d6fa6da4b0dcebc006759e7e0fd960223594dd7a23621"])
        });
        vectors[6] = HashToFieldTestVector({
            message: "q128_qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
            elements: __fix([hex"0ebb15bfb36fc8ccd31f4ac735f8ea0a9a764e5eb18d0d319133af45c7d01b62760c563563e14d2232170c6ff5e3ee5d"])
        });
        vectors[7] = HashToFieldTestVector({
            message: "q128_qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
            elements: __fix([hex"0ed3ec24df4e50a56cc0959e65af3c01a3fc8cda7e88e6920df5e219b30af6e8c6d52bcf2e585ea6040a5469bae21b21", hex"091895aec3037b7cc330d6d0d2d1ce683296d01a1002d69b3c6a4f5fae1aa75f9b7afd055a7610ebcb5220444a938903"])
        });
        vectors[8] = HashToFieldTestVector({
            message: "a512_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            elements: __fix([hex"15a4abea17269052a8653db28ac64b0aeb21ef9bf527628c8e4427bdf64a5e4da147c3898b39dc31591909cfdec9f6f3"])
        });
        vectors[9] = HashToFieldTestVector({
            message: "a512_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            elements: __fix([ hex"0ea9d344b61d06a10b85c9f1382982884b1f33c780360e277c814168d8f546cfb329e042ec84c3701c41fafc8d015c1f", hex"1789449cae4af2241b65fcaf69ef95ba233cf0feabf1aeb27c4e315ead0c7cf69120f1cf05881a284171be12f25c9337"])
        });
    }
}

abstract contract HashToG1TestVectors is BaseTestVectors {
    string internal constant HASH_TO_G1_DST = "QUUX-V01-CS02-with-BLS12381G1_XMD:SHA-256_SSWU_RO_";

    function hashToG1TestVectors() internal pure returns (HashToG1TestVector[] memory vectors) {
        vectors = new HashToG1TestVector[](5);
        vectors[0] = HashToG1TestVector({
            message: "",
            px: __fix(hex"052926add2207b76ca4fa57a8734416c8dc95e24501772c814278700eed6d1e4e8cf62d9c09db0fac349612b759e79a1"),
            py: __fix(hex"08ba738453bfed09cb546dbb0783dbb3a5f1f566ed67bb6be0e8c67e2e81a4cc68ee29813bb7994998f3eae0c9c6a265")
        });
        vectors[1] = HashToG1TestVector({
            message: "abc",
            px: __fix(hex"03567bc5ef9c690c2ab2ecdf6a96ef1c139cc0b2f284dca0a9a7943388a49a3aee664ba5379a7655d3c68900be2f6903"),
            py: __fix(hex"0b9c15f3fe6e5cf4211f346271d7b01c8f3b28be689c8429c85b67af215533311f0b8dfaaa154fa6b88176c229f2885d")
        });
        vectors[2] = HashToG1TestVector({
            message: "abcdef0123456789",
            px: __fix(hex"11e0b079dea29a68f0383ee94fed1b940995272407e3bb916bbf268c263ddd57a6a27200a784cbc248e84f357ce82d98"),
            py: __fix(hex"03a87ae2caf14e8ee52e51fa2ed8eefe80f02457004ba4d486d6aa1f517c0889501dc7413753f9599b099ebcbbd2d709")
        });
        vectors[3] = HashToG1TestVector({
            message: "q128_qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq",
            px: __fix(hex"15f68eaa693b95ccb85215dc65fa81038d69629f70aeee0d0f677cf22285e7bf58d7cb86eefe8f2e9bc3f8cb84fac488"),
            py: __fix(hex"1807a1d50c29f430b8cafc4f8638dfeeadf51211e1602a5f184443076715f91bb90a48ba1e370edce6ae1062f5e6dd38")
        });
        vectors[4] = HashToG1TestVector({
            message: "a512_aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
            px: __fix(hex"082aabae8b7dedb0e78aeb619ad3bfd9277a2f77ba7fad20ef6aabdc6c31d19ba5a6d12283553294c1825c4b3ca2dcfe"),
            py: __fix(hex"05b84ae5a942248eea39e1d91030458c40153f3b654ab7872d779ad1e942856a20c438e8d99bc8abfbf74729ce1f7ac8")
        });
    }
}

contract RFC9380Test is Test, ExpandMessageXMDTestVectors, HashToFieldTestVectors, HashToG1TestVectors, IBLSTypes {
    using BLS12381Lib for Fp;
    using BLS12381Lib for G1Point;

    function test_hash_to_curve_g1() public view {
        HashToG1TestVector[] memory vectors = hashToG1TestVectors();
        for (uint256 i = 0; i < vectors.length; i++) {
            HashToG1TestVector memory vector = vectors[i];
            G1Point result = RFC9380.hashToG1(bytes(vector.message));
            assertEq(result.x().mem(), vector.px);
            assertEq(result.y().mem(), vector.py);
        }
    }

    function test_hash_to_field() public view {
        HashToFieldTestVector[] memory vectors = hashToFieldTestVectors();
        for (uint256 i = 0; i < vectors.length; i++) {
            HashToFieldTestVector memory vector = vectors[i];
            uint256 count = vector.elements.length;
            Fp[] memory result = RFC9380.hashToFp(bytes(vector.message), HASH_TO_FIELD_DST, count);
            bytes[] memory resultBytes = new bytes[](count);
            for (uint256 j = 0; j < count; j++) {
                resultBytes[j] = result[j].mem();
            }
            assertEq(resultBytes, vector.elements);
        }
    }

    function test_expand_message_xmd() public pure {
        ExpandMessageXMDTestVector[] memory vectors = expandMessageXMDTestVectors();
        for (uint256 i = 0; i < vectors.length; i++) {
            ExpandMessageXMDTestVector memory vector = vectors[i];
            bytes memory result = RFC9380.expandMessageXMD(bytes(vector.message), XMD_DST, vector.len_in_bytes);
            assertEq(result, vector.uniform_bytes);
        }
    }
}
