// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PaperToken.sol"; 

contract DPublish {
    // mapping(string => address) public submitted_manuscripts;
    mapping(address => uint) private balances; 
    uint private submission_fee = 10; 

    PaperTokens papersMetadata; 
       
    receive() external payable {} 

    function submit_manuscript(string memory idmanuscript) public payable {
        require(!papersMetadata.isSubmitted[idmanuscript],
                "Manuscript already submitted! Wait for a review.");

	require(msg.value >= getSubmissionFee(), 
		"There is a submission fee!"); 
        PaperToken tk = new PaperToken();
 	
        papersMetadata.manuscripts.push(idmanuscript);
        uint _id = papersMetadata.manuscripts.length;
        papersMetadata.isSubmitted[idmanuscript] = true;
        papersMetadata.submittedManuscripts[address(tk)] = msg.sender;
        papersMetadata.manuscriptIdentifiers[idmanuscript] = address(tk);
    }
	

    function unsubmit_manuscript(string memory idmanuscript) public payable {
        require(papersMetadata.isSubmitted[idmanuscript],
                    "Thou must burn an existing manuscript!");
	require(checkAuthorship(msg.sender, idmanuscript), 
		"You must be the author!"); 
        address _id = papersMetadata.manuscriptIdentifiers[idmanuscript];
        // delete manuscripts[_id]; // Keep!
        delete papersMetadata.submittedManuscripts[_id];
        delete papersMetadata.manuscriptIdentifiers[idmanuscript];
	delete papersMetadata.isSubmitted[idmanuscript]; 
    }

    function checkAuthorship(address author, string memory idmanuscript) private returns(bool){
	address tk = papersMetadata.manuscriptIdentifiers[idmanuscript]; 
	address tkAuthor = papersMetadata.submittedManuscripts[tk]; 
	return (author == tkAuthor); 
    } 
    
    function setSubmissionFee(uint fee) private {
	    submission_fee = fee; 
    } 

    function getSubmissionFee() public returns(uint) {
	    return submission_fee; 
    } 

    function getBalance(address author) public view returns (uint) { 
	    return address(this).balance; 
    } 


}
