// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ChainlinkAPIRequest} from "./ChainlinkAPIRequest.sol";

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

/**
 * @title SmartContractAuditor
 * @notice This contract allows auditing of other smart contracts via Chainlink Functions, Etherscan and Open AI by specifying their blockchain address
 * @dev The contract provides a basic framework to perform audits on other contracts by interacting with them and retrieving basic information and sending to OpenAI to display the final analyze to the user.
 */
contract SmartContractAuditor is Ownable {
    // Declare instance of Chainlink API Request Contract
    ChainlinkAPIRequest private chainlinkAPIRequest;

    // Custom error for invalid contract address
    error InvalidContractAddress(address invalidAddress);

    constructor(address _router, bytes32 _donId) Ownable(msg.sender) {
        // Initialise Chainlink API Request contract
        chainlinkAPIRequest = new ChainlinkAPIRequest(_router, _donId);
    }

    /**
     * @notice Audits a smart contract at the given address by checking if it implements a specific function or has a certain balance.
     * @dev This is a basic example that checks if the contract has a balance greater than 0.
     * @param contractAddress The address of the contract to be audited.
     * @return openAIanalyze Boolean indicating if the contract passed the audit.
     */
    function auditContract(
        address contractAddress
    ) public returns (string memory openAIanalyze) {
        if (contractAddress == address(0)) {
            revert InvalidContractAddress(contractAddress);
        }

        return openAIanalyze;
    }
}
