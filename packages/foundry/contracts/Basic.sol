//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

contract Basic {
    uint256 numberA = 1;
    uint256 numberB = 2;

    constructor() {}

    function total() external view returns (uint256) {
        return (numberA + numberB);
    }
}
