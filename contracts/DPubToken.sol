// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";

contract DPubToken is ERC20, ERC20Permit, ERC20Votes {
    struct ManuscriptData {
        uint256 timestamp;
        address[] reviews;
        address author;
    }
    mapping(string => ManuscriptData) public submittedManuscripts;
    uint32 constant minReviews = 5;
    uint256 submitCost = 100;
    uint256 resubmitCost = 50;

    constructor() ERC20("DPubToken", "DPTK") ERC20Permit("DPubToken") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    // Submits a manuscript to the blockchain by its id and the address of the author.
    // Allocates the memory for the array of addresses of the reviewers.
    function submitManuscript(string calldata idManuscript) public {
        require(
            submittedManuscripts[idManuscript].author == address(0),
            "Manuscript of given ID already exists");
        submittedManuscripts[idManuscript] = ManuscriptData(
            block.timestamp,
            new address[](minReviews),
            _msgSender()
        );
    }
    
    function _resetReviews(address[] storage reviews) internal {
        for (uint256 i = 0; i < reviews.length; ++i) {
            reviews[i] = address(0);
        }
    }

    // Expects the manuscript to have been updated by the author in another interface.
    // This function merely resets the state of the manuscript to be reviewed again.
    function resubmitManuscript(string calldata idManuscript) public {
        require(
            submittedManuscripts[idManuscript].author == _msgSender(),
            "Only the author can resubmit a manuscript"
        );
        _resetReviews(submittedManuscripts[idManuscript].reviews);
    }

    function _reviewNotPresent(address[] storage reviews, address reviewer)
        internal view returns (bool) {
        for (uint256 i = 0; i < reviews.length; ++i) {
            if (reviews[i] == reviewer) {
                return false;
            }
        }
        return true;
    }

    function submitReview(string calldata idManuscript) public {
        require(
            submittedManuscripts[idManuscript].author != address(0),
            "No manuscript of given ID exists"
        );
        require(
            _reviewNotPresent(submittedManuscripts[idManuscript].reviews, _msgSender()),
            "Review already submitted by this address"
        );
        submittedManuscripts[idManuscript].reviews.push(_msgSender());
    }

    function minimumReviews() public pure returns (uint32) {
        return minReviews;
    }

    // The following functions are overrides required by Solidity.

    function _afterTokenTransfer(address from, address to, uint256 amount)
        internal override(ERC20, ERC20Votes)
    {
        super._afterTokenTransfer(from, to, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._mint(to, amount);
    }

    function _burn(address account, uint256 amount)
        internal
        override(ERC20, ERC20Votes)
    {
        super._burn(account, amount);
    }
}