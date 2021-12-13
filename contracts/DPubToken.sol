// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
// import "@openzeppelin/contracts/token/ERC777/ERC777.sol"; 

contract Utils {
	function is_in(address tk, address[] memory tkList) public returns(bool) {
		for(uint i = 0; i < tkList.length; i++) {
			if(tkList[i] == tk) 
				return true; 
		} 
		return false; 
	} 
} 

contract DPubToken is ERC20, ERC20Permit, ERC20Votes {
    constructor(
	    uint256 initialSupply 
	       ) ERC20("DPubToken", "DPTK") ERC20Permit("DPubToken") {
        _mint(msg.sender, initialSupply);
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
