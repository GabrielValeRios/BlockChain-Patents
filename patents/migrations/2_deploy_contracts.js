var Data = artifacts.require("Data");
var Patents = artifacts.require("Patents");

module.exports = function(deployer) {
	deployer.deploy(Data);
	deployer.deploy(Patents);
};
