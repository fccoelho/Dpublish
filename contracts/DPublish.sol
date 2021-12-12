// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DPublish {
    mapping(string => address) public submitted_manuscripts;

    /**
    * Submit manuscript
     */
    function submit_manuscript(string memory idmanuscript) public payable{
        submitted_manuscripts[idmanuscript] = msg.sender; 
    }

    function get_submitted_manuscript(string memory idmanuscript) public view returns (address){
	    return submitted_manuscripts[idmanuscript]; 
    } 

}
