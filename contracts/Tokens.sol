// contracts/Token.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract Token is ERC1155 {
    uint256 public constant DPub = 0;
    uint256 public constant Review = 1;
    uint256 public constant Paper = 2;
    
    constructor() ERC1155("https://dpublish.org/api/token/{id}.json") {
        _mint(msg.sender, DPub, 10**18, ""); //only DPub token is minted from the start
        
        
    }
}