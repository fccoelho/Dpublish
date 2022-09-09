# Dpublish platform

Below you can find a brief overview of the proposed architecture of the Dpublish platform.

The platform was first proposed in [this article](https://www.scielo.br/j/mioc/a/pGbLcFHfhKGvXvTYPcGrfWw/?lang=en) I wrote a few years ago.  

The platform involves establishing a [decentralized autonomous organization](https://ethereum.org/en/dao/)). Here we will call it **DAPH**, Decentralized Autonomous Publishing House.

To fully grasp the concept you should start by reading the [article](https://www.scielo.br/j/mioc/a/pGbLcFHfhKGvXvTYPcGrfWw/?lang=en).

Proposed architecture:

![Fluxograma](Fluxograma.png)

## Basic resources
The project is managed with the [Truffle](https://www.trufflesuite.com/docs/truffle/getting-started/creating-a-project) framework.

All contracts are based on [Open Zeppelin](https://github.com/openzeppelin/openzeppelin-contracts) templates. 

## Contracts

1. **[DPubToken](/contracts/DPubToken.sol)** contract to create tokens [ERC777](https://docs.openzeppelin.com/contracts/4.x/erc777) that will be used to pay for services in the *DAPH*.
1. **[ReviewToken](/contracts/ReviewToken.sol)** Nonfungible token, [ERC721](https://docs.openzeppelin.com/contracts/4.x/erc721), that will be used as a review certificate.
1. **[PaperToken](/contracts/PaperToken.sol)** Another ERC721 token to act as publishing certificates.  

2. **[Dpublish](/contracts/DPublish.sol)** This contract will define the API that will control the whole publication workflow.
3. **[DpubGovernor](/contracts/DPubGovernor.sol)** This contract with define the governance of the *DAPH*.

## Bonus
Desenvolver um frontend web para o seu projeto.


