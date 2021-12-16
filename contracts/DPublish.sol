// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/utils/Context.sol";

import "./ReviewToken.sol";
import "./PaperToken.sol";

contract DPublish is Context {
    address private Editor; // editor's address
    uint256 public publishing_fee; // publishing fee
    uint16 public desired_number_of_reviews; // desired number of reviews per paper

    /**
     * Represents a paper.
     */
    struct Paper {
        address author; // corresponding author address
        address[] reviews; // corresponding `ReviewToken`s

        string url; // URL to the paper

        uint256 value; // value available for this paper
    }
    /**
     * Represents a review.
     */
    struct Review {
        string message; // review
        uint8 rating; // rating (adapted from NeurIPS scale):
        // 0 = Trivial or wrong or known. I'm surprised anybody wrote such a paper.
        // 1 = A strong rejection. I'm suprised it was submitted here.
        // 2 = A clear rejection.
        // 3 = An OK paper, but not good enough. A rejection.
        // 4 = Marginally below the acceptance threshold.
        // 5 = Marginally above the acceptance threshold.
        // 6 = Good paper. Accept.
        // 7 = Top 50% of accepted papers, a very good paper, a clear accept.
        // 8 = Top 15% of accepted papers, an excellent paper, a strong accept.
        // 9 = Top 5% of accepted papers, a seminal paper for the ages.
    }

    /**
     * Balances of each member of our network.
     */
    mapping(address => uint256) public balances;
    /**
     * Papers under review. Maps `PaperToken`s to `Paper` structs.
     */
    mapping(address => Paper) private papers_under_review;
    /**
     * Accepted papers. Maps `PaperToken`s to `Paper` structs.
     */
    mapping(address => Paper) private accepted_papers;
    /**
     * Rejected papers. Maps `PaperToken`s to `Paper` structs.
     */
    mapping(address => Paper) private rejected_papers;
    /**
     * Reviews. Maps `ReviewToken`s to `Review` structs.
     */
    mapping(address => Review) private reviews;

    event PaymentReceived(address from, uint256 amount);

    error NotEnoughFunds(uint256 requested, uint256 available, address where);

    /**
     * Submit a manuscript
     */
    function submit_manuscript(string memory url) public payable {
        address author = msg.sender;

        // Submitting a paper has a corresponding fee.
        // Let's pay it; and, if not possible, revert with an error.
        if (balances[author] < publishing_fee)
            revert NotEnoughFunds(publishing_fee, balances[author], author);
        balances[author] -= publishing_fee;

        // Create a new paper under review
        address papertoken = address(new PaperToken());
        papers_under_review[papertoken] = Paper(
            author, // NOTE: does this break anonimity? Not necessarily
            new address[](0),
            url,
            publishing_fee
        );

        // Finally, emit an event.
        emit PaymentReceived(author, publishing_fee);
    }

    /**
     * Get a paper under review
     */
    function get_paper_under_review(address papertoken) public view returns(Paper memory) {
        return papers_under_review[papertoken];
    }

    /**
     * Get an accepted paper
     */
    function get_accepted_paper(address papertoken) public view returns(Paper memory) {
        return accepted_papers[papertoken];
    }

    /**
     * Get a rejected paper
     */
    function get_rejected_paper(address papertoken) public view returns(Paper memory) {
        return rejected_papers[papertoken];
    }

    /**
     * Review a paper
     */
    function review_paper(address papertoken, string memory review, uint8 rating) public payable {
        // NOTE: we don't check if the same reviewer is reviewing the same paper twice.
        address reviewer = msg.sender;

        // TODO check if paper really is under review
        Paper memory paper = papers_under_review[papertoken];
        require(reviewer != paper.author);

        // Reviewing a paper has a corresponding bounty.
        // Let's pay it; and, if not possible, revert with an error.
        uint256 review_bounty = publishing_fee / desired_number_of_reviews;
        if (paper.value < review_bounty)
            revert NotEnoughFunds(review_bounty, paper.value, papertoken);
        paper.value -= review_bounty;
        balances[reviewer] += review_bounty;

        // Let's save this review.
        address reviewtoken = address(new ReviewToken());
        reviews[reviewtoken] = Review(review, rating);

        emit PaymentReceived(papertoken, review_bounty);
    }

    /**
     * Accept or reject a paper
     */
    function accept_or_reject_paper(address papertoken, bool accept) public payable {
        require(msg.sender == Editor);

        // TODO check if paper really is under review
        Paper memory paper = papers_under_review[papertoken];

        if (accept)
            accepted_papers[papertoken] = paper;
        else
            rejected_papers[papertoken] = paper;
        delete papers_under_review[papertoken];
    }
}
