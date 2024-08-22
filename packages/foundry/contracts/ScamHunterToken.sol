//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {ChainlinkAPIRequest} from "./ChainlinkAPIRequest.sol";

contract ScamHunterToken is ERC20, ERC20Burnable, Ownable {
    // Declare instance of Chainlink API Request Contract
    ChainlinkAPIRequest private chainlinkAPIRequest;

    event AnalyzeFailed();

    constructor(
        address _router,
        bytes32 _donId
    ) ERC20("Scam Hunter Token", "SHT") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * (10 ** 18));
        // Initialise chainlink API Request contract
        chainlinkAPIRequest = new ChainlinkAPIRequest(_router, _donId);
    }

    // function analyzeContractSecurity() private {
    //     string memory source = "your JavaScript source code here"; // Put your JS code as a string
    //     FunctionsRequest.Location secretsLocation = FunctionsRequest
    //         .Location
    //         .Inline; // Or another location type
    //     bytes memory encryptedSecretsReference = ""; // If using secrets, include them here
    //     string;
    //     args[0] = "argument1"; // Pass arguments for the JS script

    //     bytes; // Byte arguments if any
    //     bytesArgs[0] = ""; // Example byte argument

    //     uint64 subscriptionId = 1; // Your Chainlink subscription ID
    //     uint32 callbackGasLimit = 300000; // Gas limit for callback

    //     try
    //         chainlinkAPIRequest.sendRequest(
    //             source,
    //             secretsLocation,
    //             encryptedSecretsReference,
    //             args,
    //             bytesArgs,
    //             subscriptionId,
    //             callbackGasLimit
    //         )
    //     {} catch {
    //         emit AnalyzeFailed();
    //     }
    // }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        // Check if the Chainlink API Request contract is secure

        // analyzeContractSecurity();

        // Proceed with the transfer if the contract is secure
        return super.transferFrom(sender, recipient, amount);
    }
}
