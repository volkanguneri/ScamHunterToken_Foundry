// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../contracts/ScamHunterToken.sol";

contract ScamHunterTokenTest is Test {
    ScamHunterToken public scamHunterToken;

    // function setUp() public {
    //     scamHunterToken = new ScamHunterToken(vm.addr(1));
    // }

    // function testMessageOnDeployment() public view {
    //     require(
    //         keccak256(bytes(scamHunterToken.greeting())) ==
    //             keccak256("Building Unstoppable Apps!!!")
    //     );
    // }

    // function testSetNewMessage() public {
    //     scamHunterToken.setGreeting("Learn Scaffold-ETH 2! :)");
    //     require(
    //         keccak256(bytes(scamHunterToken.greeting())) ==
    //             keccak256("Learn Scaffold-ETH 2! :)")
    //     );
    // }
}
