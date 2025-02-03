// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/BLS12381Calculator.sol";

contract BLS12381CalculatorTest is Test {
    BLS12381Calculator calculator;

    function setUp() public {
        calculator = new BLS12381Calculator();
    }

    function test_scalarToG1Point() public view {
        uint256 scalar = 123;
        bytes memory result = calculator.scalarToG1Point(scalar);
        
        assertEq(result.length, 128);
    }
}