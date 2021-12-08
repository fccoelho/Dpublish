var DPubToken = artifacts.require("DPubToken");
var PaperToken = artifacts.require("PaperToken");
var ReviewToken = artifacts.require("ReviewToken");
var DPubGovernor = artifacts.require("DPubGovernor");
// var ERC20Votes = artifacts.require("ERC20Votes");
var ERC20VotesMock = artifacts.require("ERC20VotesMock");
var Dpublish = artifacts.require("Dpublish.sol");

module.exports = function(deployer) {
  deployer.deploy(Dpublish)
  // deployer.deploy(DPubToken);
  // deployer.deploy(PaperToken);
  // deployer.deploy(ReviewToken);
  // deployer.deploy(ERC20Votes);
  // deployer.deploy(DPubGovernor);
};