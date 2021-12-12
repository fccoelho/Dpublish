// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "./PaperToken.sol"; 
import "./ReviewToken.sol"; 
import "./DPubToken.sol"; 

contract DPublish {
    // mapping(string => address) public submitted_manuscripts;
    // mapping(address => uint) private balances; 
    uint private submission_fee = 1000; 
    uint private review_fee = 99; 
    uint private rating_threshold = 9999; 
    uint private quantityReviewers = 3; // Quantity of reviewer to release a manuscript 
    uint private reviewRelease = 3; // Review, in a scale from 1 to 5, to release the manuscript 
    uint private reviewerThreshold = 2; // Reviewer score to validate its review
    
    mapping(address => address[]) tokens; // The DPubTokens of each user. 
    uint weiToDPubToken = 1000; // A (arbitrary) value to compute DPubTokens given the balance. 

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
	papersMetadata.isReleased[address(tk)] = false; 
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
	delete papersMetadata.isReleased[_id]; 
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
	reviewsMetadata.reviewToReviewer[address(tk)] = msg.sender;  
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

    // Function overflow 
    function isReviewing(address reviewer, address currReview) private returns(bool) {
	    // Check whether `reviewer` is resposible for `review`. 
	    address manuscriptToken = reviewsMetadata.papers[currReview]; 
	    address[] memory reviewerTokens = reviewsMetadata.reviewers[reviewer]; 

	    for(uint i = 0; i < reviewerTokens.length; i++) {
		    address reviewToken = reviewerTokens[i]; 
		    if (reviewToken == currReview) 
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
	    address manuscriptToken = papersMetadata.manuscriptIdentifiers[idmanuscript]; 
	    reviewsMetadata.reviews[manuscriptToken].reviews.push(score); 
	    reviewsMetadata.reviews[manuscriptToken].reviewers.push(msg.sender); 
    } 
	
    function setRatingThreshold(uint threshold) private {
	    rating_threshold = threshold; 
    } 

    function getRatingThreshold() private returns(uint) {
	    return rating_threshold; 
    } 

    function setReviewerThreshold(uint threshold) private {
	    reviewerThreshold = threshold; 
    } 

    function getReviewerThreshold() public returns(uint) {
	   return reviewerThreshold; 
    }  

    function setReviewRelease(uint threshold) private {
	    reviewRelease = threshold; 
    } 
    
    function getReviewRelease() public returns(uint) {
	    return reviewRelease; 
    } 
    
    function setQuantityReviewers(uint quantity) private {
	    quantityReviewers = quantity; 
    } 

    function getQuantityReviewers() public returns(uint) {
	    return quantityReviewers; 
    } 
   
    function rateReview(address ratingReview, uint score) public {
	     require(!isReviewing(msg.sender, ratingReview), 
		     "You shouldn't rate your own reviews!"); 
	     
	     require(msg.sender.balance >= getRatingThreshold(), 
			"There is a (stake) threshold for rating reviews!"); 
		
	     address reviewer = reviewsMetadata.reviewToReviewer[ratingReview]; 
	     reviewsMetadata.scores[reviewer].push(score); 
    } 
    
    function releaseManuscript(string memory idmanuscript) public payable {
	    // Release the manuscript. 
	    // For each review, this functions verify (1) whether
	    // the reviewer has the stake to review, (2) if the 
	    // quantity of valid reviewers is appropriate according to some 
	    // threshold and also (3) compute the ratings of the paper;  
	    // it uses, subsequently this information to decide to publish the document. 

	    address manuscriptToken = papersMetadata.manuscriptIdentifiers[idmanuscript]; 
	    ReviewsList memory reviews = reviewsMetadata.reviews[manuscriptToken];  

	    uint reviewsLength = reviews.reviews.length; 

	    uint n = 0; 
	    uint sumReviews = 0; 

	    for(uint i = 0; i < reviewsLength; i++) {
		    uint reviewScore = reviews.reviews[i]; 
		    address reviewer = reviews.reviewers[i]; 

		    bool isValidReviewer = checkReviewer(reviewer); 
		    if (isValidReviewer) {
			    n = n + 1; 
			    sumReviews = sumReviews + reviewScore; 
		    } 
    	    } 

	    if (n <= quantityReviewers) {
		    require(false, "The document must be reviewed more!"); 
		    // return false; 
	    } 
	
	    uint manuscriptReview = sumReviews/n; 
	    if (manuscriptReview <= reviewRelease) {
		    require(false, "The document doesn't has appropriate rating!"); 
	   	    // return false; 
	    } 

	    require(true, "The document will be relsead, author!"); 
	    
	    papersMetadata.isReleased[manuscriptToken] = true; 
	    
	    // return true; 

	    // Search for valid reviewers and validate fees 
	    uint manuscriptFee = papersMetadata.manuscriptsFee[manuscriptToken]; 
	    uint feePerReviewer = manuscriptFee/n; 
	
	    for(uint i = 0; i < reviewsLength; i++) {
		    address reviewer = reviews.reviewers[i]; 
		    bool isValidReviewer = checkReviewer(reviewer); 
		    if(isValidReviewer) 
			    payable(reviewer).send(feePerReviewer); 
	    } 

	    		
	} 
	
	function checkReviewer(address reviewer) public view returns(bool) {
		// Check whether reviewer has an appropriate rating; 
		// it will be used to validate its review. 
		uint[] memory scores = reviewsMetadata.scores[reviewer];
		
		uint n = 0; 
		uint sumScores = 0; 
	
		for(uint i = 0; i < scores.length; i++) { 
			sumScores = sumScores + scores[i]; 
			n = n + 1; 
		} 
		
		if (n == 0) 
			return true; 

		uint reviewerScore = sumScores/n; 
		
		if (reviewerScore <= reviewerThreshold) 
			return false; 
		else 
			return true; 
	} 


	function buyToken() public payable {
		// Buy a DPubToken. 
		require(msg.value >= weiToDPubToken, 
			"You must provide more currencies!"); 
		DPubToken tk = new DPubToken(msg.value); 
		tokens[msg.sender].push(address(tk)); 
	} 
}
