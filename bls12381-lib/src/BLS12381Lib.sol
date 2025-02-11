// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

import {Math} from "@openzeppelin/contracts/utils/math/Math.sol";

// internal name
interface _T {
    // pointers to bytes
    // NOTE: these types cannot be used in calldata
    type Fp is uint256;
    type Fp2 is uint256;
    type G1Point is uint256;
    type G2Point is uint256;
}

// external name
interface IBLSTypes is _T {}

library BLS12381Lib {
    using BLS12381Lib for _T.G1Point;
    using BLS12381Lib for _T.G2Point;
    using BLS12381Lib for _T.Fp;
    using BLS12381Lib for _T.Fp2;

    // BLS12-381 precompile addresses
    address constant G1_ADD_PRECOMPILE = address(0x0B);
    address constant G1_MSM_PRECOMPILE = address(0x0C);
    address constant G2_ADD_PRECOMPILE = address(0x0D);
    address constant G2_MSM_PRECOMPILE = address(0x0E);
    address constant PAIRING_CHECK_PRECOMPILE = address(0x0F);
    address constant MAP_FP_TO_G1_PRECOMPILE = address(0x10);
    address constant MAP_FP2_TO_G2_PRECOMPILE = address(0x11);

    // BLS12-381 G1 generator point in compressed form
    bytes constant G1_GENERATOR = hex"0000000000000000000000000000000017f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb0000000000000000000000000000000008b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1";
    bytes constant G2_GENERATOR = hex"00000000000000000000000000000000024aa2b2f08f0a91260805272dc51051c6e47ad4fa403b02b4510b647ae3d1770bac0326a805bbefd48056c8c121bdb80000000000000000000000000000000013e02b6052719f607dacd3a088274f65596bd0d09920b61ab5da61bbdc7f5049334cf11213945d57e5ac7d055d042b7e000000000000000000000000000000000ce5d527727d6e118cc9cdc6da2e351aadfd9baa8cbdd3a76d429a695160d12c923ac9cc3baca289e193548608b82801000000000000000000000000000000000606c4a02ea734cc32acd2b02bc28b99cb3e287e85a763af267492ab572e99ab3f370d275cec1da1aaa9075ff05f79be";

    /**
     * @dev Returns the generator point of the G1 group on BLS12-381
     * @return result The G1 generator point
     */
    function g1Generator() internal pure returns (_T.G1Point result) {
        bytes memory _g1Generator = G1_GENERATOR;
        assembly { result := _g1Generator }
    }

    /**
     * @dev Returns the generator point of the G2 group on BLS12-381
     * @return result The G2 generator point
     */
    function g2Generator() internal pure returns (_T.G2Point result) {
        bytes memory _g2Generator = G2_GENERATOR;
        assembly { result := _g2Generator } 
    }

    /**
     * @dev Multiplies the G1 generator point by a scalar using the G1 multi-scalar multiplication precompile
     * @param scalar The scalar to multiply the generator point by
     * @return result The resulting G1 point after scalar multiplication
     */
    function mulBaseG1(uint256 scalar) internal view returns (_T.G1Point result) {
        bytes memory input = bytes.concat(G1_GENERATOR, abi.encode(scalar));
        (bool success, bytes memory resultBytes) = G1_MSM_PRECOMPILE.staticcall(input);
        require(success, PrecompileError(resultBytes));
        assembly { result := resultBytes }
    }

    /**
     * @dev Multiplies a G1 curve point by a scalar using the G1 multi-scalar multiplication precompile
     * @param point The G1 point to multiply
     * @param scalar The scalar to multiply the point by
     * @return result The resulting G1 point after scalar multiplication
     */
    function mulG1(_T.G1Point point, uint256 scalar) internal view returns (_T.G1Point result) {
        bytes memory input = bytes.concat(point.mem(), abi.encode(scalar));
        (bool success, bytes memory resultBytes) = G1_MSM_PRECOMPILE.staticcall(input);
        require(success, PrecompileError(resultBytes));
        assembly { result := resultBytes }
    }

    /**
     * @dev Multiplies the G2 generator point by a scalar using the G2 multi-scalar multiplication precompile
     * @param scalar The scalar to multiply the generator point by
     * @return result The resulting G2 point after scalar multiplication
     */
    function mulBaseG2(uint256 scalar) internal view returns (_T.G2Point result) {
        bytes memory input = bytes.concat(G2_GENERATOR, abi.encode(scalar));
        (bool success, bytes memory resultBytes) = G2_MSM_PRECOMPILE.staticcall(input);
        require(success, PrecompileError(resultBytes));
        assembly { result := resultBytes }
    }

    /**
     * @dev Multiplies a G2 curve point by a scalar using the G2 multi-scalar multiplication precompile
     * @param point The G2 point to multiply
     * @param scalar The scalar to multiply the point by
     * @return result The resulting G2 point after scalar multiplication
     */
    function mulG2(_T.G2Point point, uint256 scalar) internal view returns (_T.G2Point result) {
        bytes memory input = bytes.concat(point.mem(), abi.encode(scalar));
        (bool success, bytes memory resultBytes) = G2_MSM_PRECOMPILE.staticcall(input);
        require(success, PrecompileError(resultBytes));
        assembly { result := resultBytes }
    }

    /**
     * @dev Converts an Fp field element to its byte representation
     * @param element The Fp field element to convert
     * @return result The byte representation of the field element
     */
    function mem(_T.Fp element) internal pure returns (bytes memory result) { assembly { result := element } }

    /**
     * @dev Converts an Fp2 field element to its byte representation
     * @param element The Fp2 field element to convert
     * @return result The byte representation of the field element
     */
    function mem(_T.Fp2 element) internal pure returns (bytes memory result) { assembly { result := element } }

    /**
     * @dev Converts a G1 curve point to its byte representation
     * @param point The G1 curve point to convert
     * @return result The byte representation of the curve point
     */
    function mem(_T.G1Point point) internal pure returns (bytes memory result) { assembly { result := point } }

    /**
     * @dev Converts a G2 curve point to its byte representation
     * @param point The G2 curve point to convert
     * @return result The byte representation of the curve point
     */
    function mem(_T.G2Point point) internal pure returns (bytes memory result) { assembly { result := point } }

    /**
     * @dev Error thrown when a precompile call fails unexpectedly
     * @param data The error data returned by the precompile
     */
    error PrecompileError(bytes data);
}

// This library implements hash-to-curve primitives as specified in RFC9380
// NOTE: that this could be less efficient than implementations that are optimized for the EVM, but it is standardized
library RFC9380 {
    uint256 constant B_IN_BYTES = 32; // SHA-256 output size in bytes
    uint256 constant S_IN_BYTES = 64; // SHA-256 block size in bytes

    // L = ceil((ceil(log2(p)) + k) / 8), where k is the security parameter
    // ceil(log2(p)) = 381, k = 128
    // ceil((381 + 128) / 8) = 64
    uint256 constant L = 64;
    // BLS12-381 base field prime
    bytes constant P = hex"1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab";

    // m = 1, extension field degree
    /**
     * @dev https://datatracker.ietf.org/doc/html/rfc9380#name-hash_to_field-implementatio
     * @dev Hashes an arbitrary input to one or more field elements in the base field Fp of BLS12-381
     * @param input The input bytes to hash
     * @param dst The domain separation tag to prevent collisions between different hash usages
     * @param count The number of field elements to generate
     * @return result An array of count field elements in Fp
     */
    function hashToFp(
        bytes memory input,
        string memory dst, 
        uint256 count
    ) internal view returns (IBLSTypes.Fp[] memory result) {
        result = new IBLSTypes.Fp[](count);
        uint16 length_in_bytes = uint16(count * L);
        bytes memory uniform_bytes = expandMessageXMD(input, dst, length_in_bytes);
        for (uint256 i = 0; i < count; i++) {
            // m - 1 = 0, so no loop
            // L * (j + i * m), m = 1, j = 0 => L * i
            uint256 elm_offset =  L * i;
            bytes memory tv = new bytes(L);
            assembly {
                mcopy(add(tv, 0x20), add(add(uniform_bytes, 0x20), elm_offset), L)
            }
            bytes memory tvp = Math.modExp(tv, hex"01", P);
            _T.Fp tvp_fp;
            assembly { tvp_fp := tvp }
            result[i] = tvp_fp;
        }
    }

    /**
     * @dev https://datatracker.ietf.org/doc/html/rfc9380#name-expand_message_xmd
     * @dev Expands a message using the expand_message_xmd method as per RFC9380.
     * @param message The input message as bytes.
     * @param dst The domain separation tag as a string.
     * @param len_in_bytes The desired length of the output in bytes.
     * @return result The expanded message as a byte array.
     */
    function expandMessageXMD(
        bytes memory message,
        string memory dst,
        uint16 len_in_bytes
    ) internal pure returns (bytes memory result) {
        // Step 1: Calculate ell
        uint256 ell = (len_in_bytes + B_IN_BYTES - 1) / B_IN_BYTES;

        // Step 2: Perform checks
        if (ell > 255) revert EllTooLarge(ell);
        if (len_in_bytes > 65535) revert LengthTooLarge(len_in_bytes);
        if (bytes(dst).length > 255) revert DSTTooLong(bytes(dst).length);

        // Step 3: Construct DST_prime
        bytes memory DST_bytes = bytes(dst);
        bytes memory DST_prime = abi.encodePacked(DST_bytes, I2OSP(uint256(DST_bytes.length), 1));

        // Step 4: Create Z_pad
        bytes memory Z_pad = I2OSP(0, S_IN_BYTES);

        // Step 5: Encode len_in_bytes
        bytes memory l_i_b_str = I2OSP(uint256(len_in_bytes), 2);

        // Step 6: Construct msg_prime
        bytes memory msg_prime = abi.encodePacked(Z_pad, message, l_i_b_str, I2OSP(0, 1), DST_prime);

        // Step 7: Compute b_0
        bytes32 b0 = sha256(msg_prime);

        // Step 8: Compute b_1
        bytes memory b0_bytes = abi.encodePacked(b0);
        bytes memory b1_input = abi.encodePacked(b0_bytes, I2OSP(1, 1), DST_prime);
        bytes32 b1 = sha256(b1_input);

        // Initialize array to hold b_i values
        bytes memory uniform_bytes = abi.encodePacked(b1);

        // Initialize previous block
        bytes32 prev_block = b1;

        // Step 9: Compute b_i for i = 2 to ell
        for (uint256 i = 2; i <= ell; i++) {
            // strxor(b0, b_{i-1})
            bytes32 xor_input = b0 ^ prev_block;

            // I2OSP(i, 1)
            bytes memory i_bytes = I2OSP(i, 1);

            // Construct input for hashing
            bytes memory bi_input = abi.encodePacked(xor_input, i_bytes, DST_prime);

            // Compute b_i
            bytes32 bi = sha256(bi_input);

            // Append b_i to uniform_bytes
            uniform_bytes = abi.encodePacked(uniform_bytes, bi);

            // Update previous block
            prev_block = bi;
        }

        // Step 11: Truncate to desired length
        assembly {
            result := uniform_bytes
            mstore(result, len_in_bytes)
        }
    }

    /**
     * @dev Converts a non-negative integer to its big-endian byte representation.
     * @param x The integer to convert.
     * @param length The desired length of the output byte array.
     * @return o The resulting byte array.
     */
    function I2OSP(uint256 x, uint256 length) internal pure returns (bytes memory o) {
        o = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            o[length - 1 - i] = bytes1(uint8(x >> (8 * i)));
        }
        return o;
    }

    error EllTooLarge(uint256 ell);
    error LengthTooLarge(uint256 len_in_bytes);
    error DSTTooLong(uint256 dst_length);
}