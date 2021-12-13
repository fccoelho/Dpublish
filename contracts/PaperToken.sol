// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

struct PaperTokens {
	string[] manuscripts; 
	mapping (string => bool) isSubmitted; 
	mapping (address => address) submittedManuscripts; 
        mapping (string => address) manuscriptIdentifiers; 
	mapping (address => uint) manuscriptsFee; 
	mapping (address => bool) isReleased; // Map paper to its current status 
	mapping (address => bool) isInReview; // Assert whether paper is in review (to avoid unsubmission) 
} 	

contract PaperToken is ERC721, ERC721URIStorage, Ownable {
    constructor() ERC721("PaperToken", "PTK") {}
    
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
