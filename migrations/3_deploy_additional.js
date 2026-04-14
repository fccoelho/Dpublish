let DPubToken = artifacts.require("DPubToken");
let PaperToken = artifacts.require("PaperToken");

module.exports = function(deployer) {
    deployer.deploy(PaperToken, DPubToken.address);
};