// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DPubToken is ERC20, ERC20Permit, ERC20Votes {
    constructor() ERC20("DPubToken", "DPTK") ERC20Permit("DPubToken") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // The following functions are overrides required by Solidity.

    // mint and burn 
    // ref: https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20-_afterTokenTransfer-address-address-uint256-
    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    // assign amount to account "to"
    // ref: https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20-_mint-address-uint256-
    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    // destroy amount from account
    // ref: https://docs.openzeppelin.com/contracts/4.x/api/token/erc20#ERC20-_burn-address-uint256-
    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}
