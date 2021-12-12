// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PaperToken.sol"; 
import "./ReviewToken.sol"; 

contract DPublish {
    // mapping(string => address) public submitted_manuscripts;
    // mapping(address => uint) private balances; 
    uint private submission_fee = 1000; 
    uint private review_fee = 99; 

    PaperTokens papersMetadata; 
    ReviewTokens reviewsMetadata; 

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

	papersMetadata.manuscriptsFee[address(tk)] = msg.value; 
	papersMetadata.status[address(tk)] = "OnSubmission"; 
    }
	

    function unsubmit_manuscript(string memory idmanuscript) public payable {
        require(papersMetadata.isSubmitted[idmanuscript],
                    "Thou must burn an existing manuscript!");
	require(checkAuthorship(msg.sender, idmanuscript), 
		"You must be the author!"); 
        address _id = papersMetadata.manuscriptIdentifiers[idmanuscript];
        // delete manuscripts[_id]; // Keep!
	
	// The sender is the author 
	payable(msg.sender).send(papersMetadata.manuscriptsFee[_id] + msg.value); 

        delete papersMetadata.submittedManuscripts[_id];
        delete papersMetadata.manuscriptIdentifiers[idmanuscript];
	delete papersMetadata.isSubmitted[idmanuscript]; 
	delete papersMetadata.manuscriptsFee[_id]; 
	delete papersMetadata.status[_id]; 
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

    function setReviewFee(uint fee) private {
	review_fee = fee; 
    } 

    function getReviewFee() public returns(uint) { 
	    return review_fee; 
    } 
    
    function registerReviewer(string memory idmanuscript) public payable {
	require(papersMetadata.isSubmitted[idmanuscript], 
		"The paper doesn't exist!"); 
	require(!isReviewing(msg.sender, idmanuscript), 
		"You're already reviewing this paper!"); 
	require(msg.value >= getReviewFee(), 
		"There is a fee for reviewing!"); 
	ReviewToken tk = new ReviewToken(); 
	reviewsMetadata.reviewers[msg.sender].push(address(tk)); 
	reviewsMetadata.papers[address(tk)] = papersMetadata.manuscriptIdentifiers[idmanuscript];   
    } 

    function isReviewing(address reviewer, string memory idmanuscript) private returns(bool) { 
	// Check whether reviewer `reviewer` is reviewing manuscript `idmanuscript`. 
	address[] memory reviewerTokens = reviewsMetadata.reviewers[reviewer]; 
	address manuscriptToken = papersMetadata.manuscriptIdentifiers[idmanuscript]; 
	for (uint i = 0; i < reviewerTokens.length; i++) {
		address token = reviewerTokens[i]; 
		address manuscript = reviewsMetadata.papers[token]; 
		if (manuscript == manuscriptToken) 
			return true; 
 	} 
	return false; 
    } 	 

    function review(string memory idmanuscript, uint score) public { 
	    require(isReviewing(msg.sender, idmanuscript), 
		    "You must register to review a paper!"); 
	    // In the real world, the reviewer would update e copyedited version 
	    // of the original paper and a rating; however, since we are not dealing, 
	    // in this script, with databases, the review will consist of a score between 
	    // the numbers 1 and 5 -- a five star rating. 
	    require(1 <= score && score <= 5, 
		    "The review must be a number between 1 and 5, reviewer!"); 
	    
    } 

}
