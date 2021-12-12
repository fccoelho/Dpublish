// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PaperToken.sol"; 

contract DPublish {
    // mapping(string => address) public submitted_manuscripts;
    mapping(address => uint) private balances; 
	
    PaperTokens papersMetadata; 

    function submit_manuscript(string memory idmanuscript) public {
        require(!papersMetadata.isSubmitted[idmanuscript],
                "Manuscript already submitted! Wait for a review.");

        PaperToken tk = new PaperToken();

        papersMetadata.manuscripts.push(idmanuscript);
        uint _id = papersMetadata.manuscripts.length;
        papersMetadata.isSubmitted[idmanuscript] = true;
        papersMetadata.submittedManuscripts[address(tk)] = msg.sender;
        papersMetadata.manuscriptsIdentifier[idmanuscript] = address(tk);
    }

    function unsubmit_manuscript(string memory idmanuscript) public {
        require(papersMetadata.isSubmitted[idmanuscript] && checkAuthor(idmanuscript, msg.sender),
                    "Thou must burn an existing manuscript!");
        address _id = papersMetadata.manuscriptsIdentifier[idmanuscript];
        // delete manuscripts[_id]; // Keep!
        delete papersMetadata.submittedManuscripts[_id];
        delete papersMetadata.manuscriptsIdentifier[idmanuscript];
	delete papersMetadata.isSubmitted[idmanuscript]; 
    }


    uint internal submission_fee = 100; 	

    function setSubmissionFee(uint fee) internal {
	    submission_fee = fee; 
    } 

    function getBalance() public view returns (uint) { 
	    return address(this).balance; 
    } 


}
