// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DPublish {
    mapping(string => address) public submitted_manuscripts;
 
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
        submitted_manuscripts[idmanuscript] = author; 
    }

    function get_submitted_manuscript(string memory idmanuscript) public view returns (address){
	    return submitted_manuscripts[idmanuscript]; 
    } 

}
