// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PaperToken.sol"; 

contract DPublish {
    // mapping(string => address) public submitted_manuscripts;
    mapping(address => uint) private balances; 

    PaperToken public papers; 

    uint internal submission_fee = 100; 	

    function setSubmissionFee(uint fee) internal {
	    submission_fee = fee; 
    } 

    function getBalance() public view returns (uint) { 
	    return address(this).balance; 
    } 

    /**
    * Submit manuscript
     */

    function submit_manuscript(string memory idmanuscript) public payable { 
	address author = msg.sender; 
        require(msg.value >= submission_fee, "there is a submission fee"); 
    }

}
