const AkapzGovernanceToken = artifacts.require("Akapz");

module.exports = async function(deployer, network, accounts) {
await deployer.deploy(AkapzGovernanceToken, "AKAP", "AKP", '0x3927235E981F4Dc8eeD2915C10027697902a9162');
};