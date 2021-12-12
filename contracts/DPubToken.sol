// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
// import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/token/ERC777/ERC777.sol"; 

contract DPubToken is ERC777 {
    constructor(
    	uint256 initialSupply, 
    	address[] memory defaultOperators 
    ) ERC777("DPubToken", "DPTK", defaultOperators) {
        _mint(msg.sender, 1000000 * 10 ** decimals(), "", "");
    }

}
