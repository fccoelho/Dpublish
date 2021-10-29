// contracts/GLDToken.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC777/ERC777.sol";

contract CMCToken is ERC777 {
    constructor(uint256 initialSupply, address[] memory defaultOperators)
        ERC777("Comic", "CMC", defaultOperators)
    {
        _mint(msg.sender, initialSupply, "", "");
    }
}