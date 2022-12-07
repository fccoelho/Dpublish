// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DPublish {
    mapping(string => address) public submitted_manuscripts;
    mapping(string => uint256) public payments; 
    mapping(address => uint256) public balance; // digital wallet

    address private reviewer; // reviewer address
    address private editor; // editor address
    uint256 public fee; // submission fee

    event PaymentReceived(address from, uint256 amount); // event to be emitted when a payment is received
    error LowFunds(uint256 requested, uint256 available); // error to be emitted when balance is insufficient

    constructor() {
        editor = msg.sender;
    }

    /**
    * Submit manuscript
     */
    function submit_manuscript(string memory idmanuscript) public payable{
        // allow the author to submit a manuscript
        submitted_manuscripts[idmanuscript] = msg.sender;
        uint funds = balance[msg.sender];

        if (fee > funds)
            revert LowFunds(fee, funds);

        balance[msg.sender] -= fee; // subtrai taxa do autor
        payments[idmanuscript] = fee; // armazena o valor pago

        emit PaymentReceived(msg.sender, fee);
    }

    function set_fee(uint256 sub_fee) public {
        // define the submission fee
        // only the editor can set the fee
        require(msg.sender == editor);
        fee = sub_fee;
    }

    function set_balance(address user, uint256 amount) public {
        // define the balance of a user
        // only the editor can set the balance
        require(msg.sender == editor);
        balance[user] = amount;
    }

    function get_balance(address user) public view returns (uint256) {
        // get user balance
        require(msg.sender == user, "Only the user can get its balance"); 
        return balance[user];
    }

}