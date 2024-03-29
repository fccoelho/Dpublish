// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

contract DPublish {
    mapping(string => address) public submitted_manuscripts;

    /**
    * Submit manuscript
     */
    function submit_manuscript(string calldata idmanuscript) public {
        submitted_manuscripts[idmanuscript] = msg.sender;
    }


}