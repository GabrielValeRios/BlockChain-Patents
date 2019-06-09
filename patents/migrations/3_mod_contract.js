var Patent = artifacts.require("Patents");

module.exports = function(deployer) {
  deployer.deploy(Patent);
};