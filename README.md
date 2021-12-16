# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain.

# Setting up the project

This project uses openzeppelin contrats, so make sure to install it in your project folder:

```bash
$ npm install @openzeppelin/contracts
```

# What was done on top of the template

The main logic and mechanisms for Dpublish were implemented in `contracts/DPublish.sol`.
It provides the following public methods:

- `submit_manuscript`: as an author, submits a manuscript to be under review.
- `get_paper_under_review`: get a paper that is under review.
- `get_accepted_paper`: get a paper that was accepted.
- `get_rejected_paper`: get a paper that was rejected.
- `review_paper`: as a reviewer, review a paper.
- `accept_or_reject_paper`: as the editor (behaving as a meta reviewer), accept or reject a given paper.

The code is well commented -- for implementation details, check that out.
