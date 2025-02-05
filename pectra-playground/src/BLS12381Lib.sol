// SPDX-License-Identifier: MIT
pragma solidity >=0.8.25;

library BLS12381Lib {
    struct G1Point {
        bytes32[2] x;
        bytes32[2] y;
    }

    struct G2Point {
        bytes32[4] x;
        bytes32[4] y;
    }

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
     * @dev Performs scalar multiplication of the BLS12-381 G1 generator point
     * @param scalar The scalar value to multiply with
     * @return result The resulting point on G1
     */
    function mulBaseG1(uint256 scalar) internal view returns (bytes memory result) {
        bytes memory input = bytes.concat(G1_GENERATOR, abi.encode(scalar));
        
        bool success;
        (success, result) = G1_MSM_PRECOMPILE.staticcall(input);
        require(success, UnexpectedError(result));
        
        return result;
    }

    /**
     * @dev Performs scalar multiplication of the BLS12-381 G2 generator point
     * @param scalar The scalar value to multiply with
     * @return result The resulting point on G2
     */
    function mulBaseG2(uint256 scalar) internal view returns (bytes memory result) {
        bytes memory input = bytes.concat(G2_GENERATOR, abi.encode(scalar));
        
        bool success;
        (success, result) = G2_MSM_PRECOMPILE.staticcall(input);
        require(success, UnexpectedError(result));
        
        return result;
    }

    error UnexpectedError(bytes data);
}