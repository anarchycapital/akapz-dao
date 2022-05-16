const AKXToken = artifacts.require("AKX");

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(AKXToken, "AKX Token", "AKX");
};
