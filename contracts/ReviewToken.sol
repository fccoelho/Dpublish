// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

struct ReviewsList { 
	address[] reviewers; 
        uint[] reviews; 
} 

struct ReviewTokens {
	mapping (address => address) papers; // Map a review token to the paper 
	mapping (address => address[]) reviewers; // Map a reviewer to a set of review tokens  
      	mapping (address => ReviewsList) reviews; // Map a paper to a set of (reviewers, reviews)  
	mapping (address => uint[]) score; // Map a reviewer to its current score  
	mapping (address => address) reviewToReviewer; // Map review to reviewer 
} 

contract ReviewToken is ERC721, ERC721URIStorage, Ownable {
    constructor() ERC721("ReviewToken", "RTK") {}

    function _baseURI() internal pure override returns (string memory) {
        return "https://dpublish.org";
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }

    // The following functions are overrides required by Solidity.

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }
}
