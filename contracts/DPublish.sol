// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/utils/Address.sol";

contract DPublish is Context{
    
    ///mapping connection URI of the manuscript to address of the author
    mapping(string => address) public submitted_manuscripts;
    mapping(address => uint256) public balances; ///Amount of DPubTokens users have
    mapping(string => uint256) public bounties; /// payment for revierwers
    address private Editor;
    uint256 public publishing_fee; /// minimum fee for publishing an article.
    uint16 public review_time; ///time to complete a review in number of blocks
    ///events
    event PaymentReceived(address from, uint256 amount);
    ///errors
    error NotEnoughFunds(uint256 requested, uint256 available);

    constructor(){
        Editor = msg.sender;
    }

    /**
    * Submit manuscript
    * pay publishing fee
     */
    function submit_manuscript(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = msg.sender;
        uint balance = balances[msg.sender];
        if (balance < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balance);
        balances[msg.sender] -= publishing_fee;
        bounties[idmanuscript] = publishing_fee;
        emit PaymentReceived(msg.sender, publishing_fee);
        
    }

    function set_fee(uint256 fee) public payable{
        require(msg.sender == Editor);
        publishing_fee = fee;
    }

    /**
    * Set  the balance of DPubTokens
     */
    function set_balance(address user, uint256 valeu) public {
        require(msg.sender == Editor);
        // implementar
    }

}