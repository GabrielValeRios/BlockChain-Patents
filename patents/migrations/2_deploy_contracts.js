var Adoption = artifacts.require("Adoption");
var Patents = artifacts.require("Patents");

module.exports = function(deployer) {
	deployer.deploy(Patents);
	deployer.deploy(Adoption);
};
