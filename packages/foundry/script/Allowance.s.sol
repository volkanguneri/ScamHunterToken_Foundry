// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/ScamHunterToken.sol";
import "forge-std/Script.sol"; // Import Script to use `vm`
import "forge-std/console.sol"; // Import console for logging

contract AllowanceScript is Script {
    function run() external {
        // Reference the ScamHunterToken contract
        ScamHunterToken scamHunterToken = ScamHunterToken(
            0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512
        );

        // Ensure the address executing the script is the owner
        require(msg.sender == scamHunterToken.owner(), "Not the owner");

        // Start the transaction using your account
        vm.startBroadcast(msg.sender);

        // Spender address
        // address spender = 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f;
        address recipient = 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f; // Recipient address (same as spender for this example)

        // Amount to be transferred (1 ETH in wei)
        uint256 amount = 1 * (10 ** 18);

        // Set an allowance
        // scamHunterToken.forceApprove(msg.sender, amount);
        scamHunterToken.approve(msg.sender, amount);

        // Verify the allowance
        uint256 allowance = scamHunterToken.allowance(msg.sender, msg.sender);
        console.log("Allowance set: ", allowance);
        require(allowance == amount, "Allowance not set correctly");

        // Log success
        console.log("Allowance set correctly for spender to transfer tokens.");

        // Transfer tokens
        // Ensure the sender has enough balance before attempting transfer
        uint256 balance = scamHunterToken.balanceOf(msg.sender);
        console.log("msg.sender balance: ", balance);
        require(balance >= amount, "Insufficient balance for transfer");

        // // Execute transferFrom
        scamHunterToken.transferFrom(msg.sender, recipient, amount);

        // End the transaction
        vm.stopBroadcast();
    }
}
