var DPubToken = artifacts.require("DPubToken");
var PaperToken = artifacts.require("PaperToken");
var ReviewToken = artifacts.require("ReviewToken");
var DPubGovernor = artifacts.require("DPubGovernor");
var ERC20Votes = artifacts.require("ERC20Votes");
// var ERC20VotesMock = artifacts.require("ERC20VotesMock");

module.exports = function(deployer) {
//  deployer.deploy(DPubToken);
//  deployer.deploy(PaperToken);
  deployer.deploy(ReviewToken);
//  deployer.deploy(ERC20Votes)
//   deployer.deploy(DPubGovernor);
};