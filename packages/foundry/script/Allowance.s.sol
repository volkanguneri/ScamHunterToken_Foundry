// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/ScamHunterToken.sol";
import "forge-std/console.sol"; // Assurez-vous que forge-std est importé pour l'affichage en console

contract Allowance {
    function run() external {
        // Adresse du spender (celui qui reçoit la permission)
        address spender = 0x23618e81E3f5cdF7f54C3d65f7FBc0aBf5B21E8f;

        // Adresse du contrat ScamHunterToken (à remplacer par l'adresse déployée)
        ScamHunterToken scamHunterToken = ScamHunterToken(
            0x2279B7A0a67DB372996a5FaB50D91eAA73d2eBe6 // Assurez-vous que cette adresse est correcte
        );

        // Afficher l'adresse du contrat pour confirmation
        console.log("ScamHunterToken address: ", address(scamHunterToken));
        console.log("this: ", address(this));

        // Création d'une allowance pour que `spender` puisse envoyer 1 SHT
        uint256 amount = 1 * (10 ** 18);
        scamHunterToken.forceApprove(spender, amount);

        // Vérification de l'allowance
        uint256 allowance = scamHunterToken.allowance(msg.sender, spender);
        console.log("Allowance set: ", allowance);
        require(allowance == amount, "Allowance not set correctly");

        // Afficher l'allowance dans la console
        console.log("Allowance set correctly for spender to transfer tokens.");
    }
}
