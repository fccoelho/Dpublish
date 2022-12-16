let DPubToken = artifacts.require("DPubToken");
let ReviewToken = artifacts.require("ReviewToken");
let DPubGovernor = artifacts.require("DPubGovernor");
// var ERC20Votes = artifacts.require("ERC20Votes");
// var ERC20VotesMock = artifacts.require("ERC20VotesMock");

module.exports = function(deployer) {
 deployer.deploy(DPubToken);
 deployer.deploy(ReviewToken);
//  deployer.deploy(ERC20Votes);
//   deployer.deploy(DPubGovernor);
};