// SPDX-License-Identifier: MIT
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

    address public contractAddress;

    // Mapping for analysis (adjust according to actual requirements)
    mapping(address => bool) public analyzed;
    mapping(address => string) public analyze;

    constructor(
        address _router,
        bytes32 _donId
    ) ERC20("Scam Hunter Token", "SHT") Ownable(msg.sender) {
        _mint(msg.sender, 1000000 * (10 ** 18));
        // Initialise Chainlink API Request contract
        chainlinkAPIRequest = new ChainlinkAPIRequest(_router, _donId);
    }

    function approve(
        address spender,
        uint256 amount
    ) public override returns (bool) {
        contractAddress = spender;
        analyzeContract();
        return super.approve(spender, amount);
    }

    function analyzeContract() internal {
        analyzed[contractAddress] = true;
    }
}
