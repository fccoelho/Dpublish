// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

// Imports the base contract for the DPubToken so that its functions can be called
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract PaperToken is ERC721, ERC721URIStorage, Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
    IERC20 DPTKContract;
    uint256 publishCost = 1000;

    constructor(IERC20 DPubTokenContractAddress) ERC721("PaperToken", "PTK") {
        DPTKContract = DPubTokenContractAddress;
    }

    function _baseURI() internal pure override returns (string memory) {
        return "https://dpublish.org";
    }

    // Mints a PaperToken by transferring the publish cost from the caller to the contract
    function safeMint(string memory _tokenURI) public {
        require(DPTKContract.allowance(_msgSender(), address(this)) >= publishCost,
            "Not enough allowance. This operation requires calling the `approve`"
            "or `increaseAllowance` functions on the DPubToken contract with this"
            "contract's address and a value that covers the publish cost as arguments.");
        DPTKContract.transferFrom(_msgSender(), address(DPTKContract), publishCost);
        uint256 newTokenId = _tokenIds.current();
        _safeMint(_msgSender(), newTokenId, "");
        _setTokenURI(newTokenId, _tokenURI);
        // Emits the event which signals that a new token has been minted
        emit Transfer(address(0), _msgSender(), newTokenId);
        _tokenIds.increment();
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