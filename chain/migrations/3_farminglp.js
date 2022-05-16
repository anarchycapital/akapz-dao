const AkapzFarmingLPToken = artifacts.require("AkapzFarmingLPToken");

module.exports = async function(deployer, network, accounts) {
await deployer.deploy(AkapzFarmingLPToken);
};