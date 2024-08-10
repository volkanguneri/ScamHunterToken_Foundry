//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

import {ERC20} from "packages/foundry/lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "packages/foundry/lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";

import {ChainlinkAPIRequest} from "./ChainlinkAPIRequest.sol";

contract ScamHunterToken is ERC20, ERC20Burnable {
    // Declare instance of Chainlink API Request Contract
    ChainlinkAPIRequest private chainlinkAPIRequest;

    event AnalyzeFailed();

    constructor(
        address _router,
        bytes32 _donId
    ) ERC20("Scam Hunter Token", "SHT") {
        _mint(msg.sender, 1000000 * (10 ** 18));
        // Initialise chainlink API Request contract
        chainlinkAPIRequest = new ChainlinkAPIRequest(_router, _donId);
    }

    function analyzeContractSecurity() private {
        try chainlinkAPIRequest.sendRequest() {} catch {
            emit AnalyzeFailed();
        }
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        // Check if the Chainlink API Request contract is secure

        analyzeContractSecurity(sender);

        // Proceed with the transfer if the contract is secure
        return super.transferFrom(sender, recipient, amount);
    }
}
