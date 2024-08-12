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

    function setUp() public {
        owner = msg.sender;
        spender = msg.sender;
        recipient = address(0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f);

        token = new ScamHunterToken(owner, bytes32(0));
        token.transfer(owner, 1000 * (10 ** 18)); // Mint some tokens to the owner
    }

    function testForceApprove() public {
        uint256 amount = 100 * (10 ** 18);

        // Execute forceApprove
        token.forceApprove(spender, amount);

        // Check allowance
        uint256 allowance = token.allowance(owner, spender);
        assertEq(allowance, amount, "Allowance should be set correctly");
    }

    function testTransferFrom() public {
        uint256 amount = 50 * (10 ** 18);

        // Set an allowance
        token.forceApprove(spender, amount);

        // Transfer tokens to the spender
        token.transferFrom(owner, spender, amount);

        // Ensure the spender can transfer tokens
        uint256 spenderBalanceBefore = token.balanceOf(spender);
        assertEq(
            spenderBalanceBefore,
            amount,
            "Spender should have received tokens"
        );

        // Execute transferFrom by the spender
        vm.prank(spender); // Set the context to the spender
        token.transferFrom(owner, recipient, amount);

        // Verify the recipient's balance
        uint256 recipientBalance = token.balanceOf(recipient);
        assertEq(recipientBalance, amount, "Recipient should receive tokens");

        // Verify the spender's balance
        uint256 spenderBalanceAfter = token.balanceOf(spender);
        assertEq(spenderBalanceAfter, 0, "Spender should not hold any tokens");
    }

    function testTransferFromInsufficientAllowance() public {
        uint256 amount = 100 * (10 ** 18);

        // Attempt to transfer more than the allowance
        vm.expectRevert("ERC20: insufficient allowance");
        vm.prank(spender);
        token.transferFrom(owner, recipient, amount);
    }

    function testTransferFromInsufficientBalance() public {
        uint256 amount = 100 * (10 ** 18);

        // Approve an amount less than the balance
        token.forceApprove(spender, amount);

        // Transfer tokens to the spender
        token.transferFrom(owner, spender, amount);

        // Attempt to transfer more tokens than the spender has
        vm.expectRevert("ERC20: transfer amount exceeds balance");
        vm.prank(spender);
        token.transferFrom(owner, recipient, amount + 1);
    }
}
