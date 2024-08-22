// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/ScamHunterToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ScamHunterTokenTest is Test {
    ScamHunterToken public token;
    address public owner;
    address public spender;
    address public recipient;

    error MissingEnvironmentVariable(string);

    function setUp() public {
        owner = msg.sender; // Use the second predefined account as the owner
        spender = vm.addr(2); // Use the third predefined account as the spender
        recipient = vm.addr(3); // Use the fourth predefined account as the recipient

        // Fetch the _router and _donId from environment variables
        address routerAddress = vm.envAddress("CHAINLINK_SEPOLIA_ROUTER");
        if (routerAddress == address(0)) {
            revert MissingEnvironmentVariable(
                "ROUTER environment variable is not set or is an invalid address."
            );
        }

        bytes32 donIdBytes32 = vm.envBytes32("CHAINLINK_SEPOLIA_DONID");
        if (donIdBytes32 == bytes32(0)) {
            revert MissingEnvironmentVariable(
                "DONID environment variable is not set or is an invalid address."
            );
        }

        token = new ScamHunterToken(routerAddress, donIdBytes32);
        token.transfer(owner, 1000 * (10 ** 18)); // Mint some tokens to the owner
    }

    function testApprove() public {
        uint256 amount = 100 * (10 ** 18);
        vm.prank(owner);
        token.approve(spender, amount);
        // Check allowance
        uint256 allowance = token.allowance(owner, spender);
        assertEq(allowance, amount, "Allowance should be set correctly");
    }

    function testTransferFrom() public {
        uint256 amount = 100 * (10 ** 18);
        vm.prank(owner);
        // Set an allowance
        token.approve(spender, amount);
        // Transfer tokens to the spender
        vm.prank(spender);
        token.transferFrom(owner, spender, amount);
        // Ensure the spender can transfer tokens
        uint256 spenderBalanceBefore = token.balanceOf(spender);
        assertEq(
            spenderBalanceBefore,
            amount,
            "Spender should have received tokens"
        );

        // // Execute transferFrom by the spender
        // vm.prank(spender); // Set the context to the spender
        // token.transferFrom(owner, recipient, amount);

        // // Verify the recipient's balance
        // uint256 recipientBalance = token.balanceOf(recipient);
        // assertEq(recipientBalance, amount, "Recipient should receive tokens");

        // // Verify the spender's balance
        // uint256 spenderBalanceAfter = token.balanceOf(spender);
        // assertEq(spenderBalanceAfter, 0, "Spender should not hold any tokens");
    }

    // function testTransferFromInsufficientAllowance() public {
    //     uint256 amount = 100 * (10 ** 18);

    //     // Attempt to transfer more than the allowance
    //     vm.expectRevert("ERC20: insufficient allowance");
    //     vm.prank(spender);
    //     token.transferFrom(owner, recipient, amount);
    // }

    // function testTransferFromInsufficientBalance() public {
    //     uint256 amount = 100 * (10 ** 18);

    //     // Approve an amount less than the balance
    //     // token.forceApprove(spender, amount);
    //     token.approve(spender, amount);

    //     // Transfer tokens to the spender
    //     token.transferFrom(owner, spender, amount);

    //     // Attempt to transfer more tokens than the spender has
    //     vm.expectRevert("ERC20: transfer amount exceeds balance");
    //     vm.prank(spender);
    //     token.transferFrom(owner, recipient, amount + 1);
    // }
}
