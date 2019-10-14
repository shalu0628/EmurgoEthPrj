var DriverRegister = artifacts.require("./DriverRegister.sol");

module.exports = function(deployer) {
    deployer.deploy(DriverRegister);
};