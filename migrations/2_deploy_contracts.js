const DPubToken = artifacts.require("DPubToken");
const PaperToken = artifacts.require("PaperToken");
const ReviewToken = artifacts.require("ReviewToken");
const DPubGovernor = artifacts.require("DPubGovernor");
const ERC20Votes = artifacts.require("ERC20Votes");
// var ERC20VotesMock = artifacts.require("ERC20VotesMock");

require('@openzeppelin/test-helpers/configure')({ provider: web3.currentProvider, environment: 'brownie' });

const { singletons } = require('@openzeppelin/test-helpers');

module.exports = async function (deployer, network, accounts) {
  // if (network === 'development') {
    // In a test environment an ERC777 token requires deploying an ERC1820 registry
    await singletons.ERC1820Registry(accounts[0]);
  // }

  await deployer.deploy(DPubToken);
  await deployer.deploy(PaperToken);
  await deployer.deploy(ERC20Votes); 
  await deployer.deploy(ReviewToken); 
}; 
