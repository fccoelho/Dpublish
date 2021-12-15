// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DPublish {
    mapping(string => address) public submitted_manuscripts;
    
    mapping(address => uint256) public balances;
    mapping(string => uint256 ) public bounties;
    mapping(address => bool) public reviewer;
    mapping(address => string) public review_history;
    address private editor;
    uint256 public publishing_fee;
    uint16 public payment_check;
    address[10] reviewers;
    uint16 count_review = 0;

    event payment_received(address from, uint256 amount);
    error not_enough_funds(uint256 requested, uint256 available);
    constructor(){
        editor = msg.sender;
        //balances[editor] = 0;
        //bounties[editor] = 0;
        //reviewer[editor] = true;
        //review_history[editor] = true;
        //payment_check = 0;
        //for(uint16 i = 0; i < 10; i++){
        //    reviewers[i] = 0x0;
        //}
    }

    function submit_manuscript(string memory idmanuscript) public payable {
        submitted_manuscripts[idmanuscript] = msg.sender;
        if (balances[msg.sender] < publishing_fee){
            revert not_enough_funds(publishing_fee, balances[msg.sender]);
        }
        balances[msg.sender] = balances[msg.sender] - publishing_fee;
        bounties[idmanuscript] = publishing_fee;
        emit payment_received(msg.sender, msg.value);
    }

    function set_fee(uint256 fee) public payable{
        require(msg.sender == editor);
        publishing_fee = fee;
    }

    function set_balance(address addr, uint256 balance) public{
        require(msg.sender == editor);
        balances[addr] = balance;
    }

    function update_review(address addr) public{
        require(msg.sender == editor);
        reviewers[count_review] = addr;
        count_review++;
        reviewer[addr] = true;
    }

    function pay_review(address reviewer_) private{
        balances[reviewer_] += payment_check;
    }

    function send_review(string memory link) public{
        require(reviewer[msg.sender] == true);
        review_history[msg.sender] = link;
        balances[msg.sender] = balances[msg.sender] - payment_check;
        pay_review(msg.sender);
    }
}