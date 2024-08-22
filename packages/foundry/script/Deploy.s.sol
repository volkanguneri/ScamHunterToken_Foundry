//

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/ScamHunterToken.sol";
import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);
    error MissingEnvironmentVariable(string);

    function run() external {
        // Setup the environment and get the deployer's private key
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }

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

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy the ScamHunterToken contract with the fetched and converted parameters
        ScamHunterToken scamHunterToken = new ScamHunterToken(
            routerAddress,
            donIdBytes32
        );

        // Log the address of the deployed contract
        console.logString(
            string.concat(
                "ScamHunterToken deployed at: ",
                vm.toString(address(scamHunterToken))
            )
        );

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Export ABI and contract information
        exportDeployments();
    }

    function stringToBytes32(
        string memory source
    ) internal pure returns (bytes32 result) {
        bytes memory tempEmptyStringTest = bytes(source);
        if (tempEmptyStringTest.length == 0) {
            return 0x0;
        }

        assembly {
            result := mload(add(source, 32))
        }
    }

    function test() public {}
}
