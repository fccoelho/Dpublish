pragma solidity ^0.8.0;

contract Comic_Stand {
    address[16] public buyers;
    
    // Buying a comic
    function buy(uint comicId) public returns (uint) {
        require(comicId >= 0 && comicId <= 15);

        buyers[comicId] = msg.sender;

        return comicId;
    }
    
    // Retrieving the buyers
    function getBuyers() public view returns (address[16] memory) {
        return buyers;
    }
    
}