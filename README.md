# Dpublish
Distributed platform for peer-reviewing scientific articles based on the Ethereum Blockchain.

# Setting up the project

This project uses openzeppelin contrats, so make sure to install it in your project folder:

```bash
$ npm install @openzeppelin/contracts
```

# An overview 

In this section, we will provide a description of what we did and, equally important, what we didn't do. Initially, however, we will reiterate that our goal is the reproduction of the Descentralized Autonomous Organization (DAO; henceforth, DAPH) described in [this paper](https://www.arca.fiocruz.br/handle/icict/41380), which proposes a high-level view of a blockchain based mechanism to decentralize scientific publishing; in particular, we should make an implementation compatible with [Ethereum](https://ethereum.org/en/) and, for this, we use [Solidity](https://docs.soliditylang.org/en/v0.8.10/). 

In this context, we started with the implementation of the roots of DAPH; namely, the `contracts`, which are, to some extent, the objects of Solidity: specifically, there are a contract for the tokens, `DPubToken`, a pair of non-fungible tokens (NFT), `ReviewToken` and `PaperToken`, and a contract to manage the system, allowing, for intance, a user to submit a paper and another user to review it, the `DPublish`. The NFTs, in this sense, are grounded on the [ERC721](https://ethereum.org/en/developers/docs/standards/tokens/erc-721/) token standard; `DPubToken`, on the other hand, was aligned with [ERC20](https://ethereum.org/en/developers/docs/standards/tokens/erc-20/) -- but, in the most positive scenario, it should be a [ERC777](https://ethereum.org/en/developers/docs/standards/tokens/erc-777/), yet this standard has, in its source code, an inconvenient and not adaptable to a local network feature, 

```sol 
    IERC1820Registry internal constant _ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
```

(precisely, line 32 of [this file](https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC777/ERC777.sol)), so we used, in our implementation, ERC20, which was sufficiently appropriate. 

We have, then, the tokens; the next step is, in this scenario, to design a script that will allow the commerce of those tokens, which is the task of `DPublish` (the Solidity code is avaible in [this file](./contracts/DPublish.sol). Empathically, the authors, the users of DAPH, should (1) submit a manuscript, (2) review other manuscripts and (3) check the current state of her documents. So, for the submission, we implemented a payable function that is responsible for this task, initialzing, in particular, the metadata of the document (for instance, the identifier of the author, its current state, its address in the blockchain and how much was paid for the submission -- this payment, by the way, should respect a threshold, the submission fee); correlatively, there is a function to unsubmit (and, frankly, to recover the initial payment) the manuscript, which, importantly, checks whether someone is revewing the paper. The review, on the other hand, is dual: it assigns a score to a manuscript (in a real world application, this would possibly contemplate the submission of a copyedited version of the document), but it has itself a score; that is, the authors should review the review. For this task, a triplet of procedures were implemented: `registerReviewer` is responsible to assign a reviewer to a document; `review`, to subsequently allow the user to provide a score to what she read; and `rateReview`, with which other authors can read the review and, pleonastically, review it; those declarations, then, provide the attributes to, posteriorously, release the paper to its possible publication -- this is the task of `releaseManuscript`. 

Now, the [paper](https://www.arca.fiocruz.br/handle/icict/41380) proposes the declaration of a set of editors to prepare the preprint to publication; however, since the tasks of those group would be aligned with real world applications -- writings editorals and organizing collections --, this role would be inadequate in our implementation. Crucially, still, the document describes the randomness of the formation of a steering commitee to manage DAPH; although this is plausible, Solidity contracts are [deterministic](https://stackoverflow.com/questions/48848948/how-to-generate-a-random-number-in-solidity), so we possibly would have to use Brownie and Ganache to simulate a blockchain and, periodically, randomly assign editors to a commitee. In this scenario, we confronted the EIP ([Ethereum Improvement Proposals](https://github.com/ethereum/EIPs)) 170 (available in [this link](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-170.md)), which imposes contraints in the file size for the contract; in particular, if you want to use Brownie and execute our contracts, please use the configuration file [network-config.yaml](./network-config.yaml) (you could, for instance, execute 

```sh 
mv network-config.yaml ~/.brownie/ 
``` 

if the dotfile `.brownie` is located at `~` in your machine). 

Therefore, we implemented a (simple) blockchain based system to manage scientific publications; to verify that it is conveniently executing its procedures, we designed some tests (in the folder [tests](./tests/)), which check the proper behaviour of submissions, reviews and release of manuscripts (look at, for instance, the file [tests/test_DPublish.py](./tests/test_DPublish.py)) -- if you want to use them, execute (using the configuration file [network-config.yaml](./network-config.yaml))  

```
brownie test 
``` 

in your terminal ([Brownie](https://eth-brownie.readthedocs.io/en/stable/) should be installed for this!), which should culminate in the following image. 

<img src = ./imgs/tests.png></img> 


