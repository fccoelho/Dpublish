// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

struct Manuscript {
    address[] authors;
}

contract DPublish {
    mapping(string => Manuscript) submitted_manuscripts;

    /**
     * Submit manuscript
     */
    function submit_manuscript(string calldata idmanuscript) public {
        require(
            submitted_manuscripts[idmanuscript].authors.length == 0,
            "Manuscript already exists"
        );

        submitted_manuscripts[idmanuscript].authors.push(msg.sender);
    }

    function add_author(string calldata idmanuscript, address author) public {
        require(
            submitted_manuscripts[idmanuscript].authors.length > 0,
            "Manuscript does not exist"
        );

        require(
            submitted_manuscripts[idmanuscript].authors[0] == msg.sender,
            "Only the first author can add authors"
        );

        for (uint256 i = 0; i < submitted_manuscripts[idmanuscript].authors.length; i++) {
            require(
                submitted_manuscripts[idmanuscript].authors[i] != author,
                "Author already exists"
            );
        }

        submitted_manuscripts[idmanuscript].authors.push(author);
    }
}
