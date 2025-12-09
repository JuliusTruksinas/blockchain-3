const TutorMarketplace = artifacts.require("TutorMarketplace");

module.exports = function (deployer) {
  deployer.deploy(TutorMarketplace);
};