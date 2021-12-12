// utils.sol

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
