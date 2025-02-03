// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {console} from "forge-std/console.sol";

contract BLS12381Calculator {
    address constant G1_ADD_PRECOMPILE = address(0x0B);
    address constant G1_MSM_PRECOMPILE = address(0x0C);

    bytes constant G1_GENERATOR = hex"0000000000000000000000000000000017f1d3a73197d7942695638c4fa9ac0fc3688c4f9774b905a14e3a3f171bac586c55e83ff97a1aeffb3af00adb22c6bb0000000000000000000000000000000008b3f481e3aaa0f1a09e30ed741d8ae4fcf5e095d5d00af600db18cb2c04b3edd03cc744a2888ae40caa232946c5e7e1";

    function scalarToG1Point(uint256 scalar) public view returns (bytes memory result) {
        bytes memory input = bytes.concat(G1_GENERATOR, abi.encode(scalar));
        
        bool success;
        (success, result) = G1_MSM_PRECOMPILE.staticcall(input);
        require(success, "G1 scalar multiplication failed");
        
        return result;
    }
}
