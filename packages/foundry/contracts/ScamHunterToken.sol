//SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

// Useful for debugging. Remove when deploying to a live network.
import "forge-std/console.sol";

import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import {ERC20Burnable} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

import {ChainlinkAPIRequest} from "./ChainlinkAPIRequest.sol";

contract ScamHunterToken is ERC20, ERC20Burnable, Ownable {
    using SafeERC20 for ERC20;
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
    //     try chainlinkAPIRequest.sendRequest() {} catch {
    //         emit AnalyzeFailed();
    //     }
    // }

    // Forcefully approve an allowance
    function forceApprove(address spender, uint256 amount) external onlyOwner {
        // Directly use ERC20's approve function
        _approve(address(this), spender, amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public override returns (bool) {
        // Check if the Chainlink API Request contract is secure

        // analyzeContractSecurity();

        console.log("Sender address:", sender);

        // Proceed with the transfer if the contract is secure
        return super.transferFrom(sender, recipient, amount);
    }
}

// pragma solidity ^0.8.19;

// import {ERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
// // import {IERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
// import {ERC20Burnable} from "../lib/openzeppelin-contracts/contracts/token/ERC20/extensions/ERC20Burnable.sol";
// import {SafeERC20} from "../lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";

// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

// import "./ChainlinkAPIRequest.sol"; //
// import "forge-std/console.sol";

// contract ScamHunterToken is ERC20, ERC20Burnable, Ownable {
//     using SafeERC20 for ERC20;

//     // Declare instance of Chainlink API Request Contract
//     ChainlinkAPIRequest private chainlinkAPIRequest;

//     // Event for Chainlink API request failure
//     event AnalyzeFailed();

//     // Constructor to initialize the token
//     constructor(
//         address _router,
//         bytes32 _donId
//     ) ERC20("Scam Hunter Token", "SHT") Ownable(msg.sender) {
//         _mint(msg.sender, 1000000 * 10 ** 18); // Mint initial tokens
//         // Initialize Chainlink API Request contract
//         chainlinkAPIRequest = new ChainlinkAPIRequest(_router, _donId);
//     }

//     // // Example function to securely transfer tokens
//     // function secureTransfer(
//     //     address recipient,
//     //     uint256 amount
//     // ) external onlyOwner {
//     //     // Using SafeERC20 to securely transfer tokens
//     //     IERC20(address(this)).safeTransfer(recipient, amount);
//     // }

//     // Example function to securely approve tokens
//     function secureApprove(address spender, uint256 amount) external onlyOwner {
//         // Using SafeERC20 to securely approve tokens
//         .safeApprove(spender, amount);
//     }

//     // // Example function to securely transfer tokens from one address to another
//     // function secureTransferFrom(
//     //     address from,
//     //     address to,
//     //     uint256 amount
//     // ) external onlyOwner {
//     //     // Using SafeERC20 to securely transfer tokens from one address to another
//     //     IERC20(address(this)).safeTransferFrom(from, to, amount);
//     // }

//     // Function to handle token transfers, which could include additional security checks
//     function transferFrom(
//         address sender,
//         address recipient,
//         uint256 amount
//     ) public override returns (bool) {
//         // Check if the Chainlink API Request contract is secure
//         // analyzeContractSecurity(); // Uncomment if you have this method implemented

//         // Log sender information for debugging
//         console.log("Sender address:", sender);

//         // Proceed with the transfer if the contract is secure
//         return super.transferFrom(sender, recipient, amount);
//     }

//     // Private function to handle Chainlink API request (implementation required)
//     // private function analyzeContractSecurity() private {
//     //     try chainlinkAPIRequest.sendRequest() {} catch {
//     //         emit AnalyzeFailed();
//     //     }
//     // }
// }
