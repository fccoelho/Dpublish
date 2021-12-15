// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract PaperToken is ERC721, ERC721URIStorage, Ownable {
    uint256 private tokenID;

    function newID() public returns(uint256){
        tokenID = tokenID + 1;
        return tokenID;
    }

    constructor() ERC721("PaperToken", "PTK") {
        tokenID =1;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://dpublish.org";
    }

    function safeMint(address to, uint256 tokenId) public onlyOwner {
        _safeMint(to, tokenId);
    }
    
    function register(address to, uint256 userId) public onlyOwner {
        register(to, userId);
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