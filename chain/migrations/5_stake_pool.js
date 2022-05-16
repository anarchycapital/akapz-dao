const AkapzStakePool = artifacts.require("AKAPZStakePool");
const AKXToken = artifacts.require("AKX");
const AkapzFarmingLPToken = artifacts.require("AkapzFarmingLPToken");
const AkapzGovernanceToken = artifacts.require("Akapz");



const _AkapzToken = AKXToken.address;
const _AkapzFarmingLPToken = AkapzFarmingLPToken.address;
const _AkapzGovernanceToken = AkapzGovernanceToken.address;
let _uniswapV2Factory;
let _uniswapV2Router02;


module.exports = async function(deployer, network, accounts) {

        _uniswapV2Factory = '0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f';
        _uniswapV2Router02 = '0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D';


    await deployer.deploy(AkapzStakePool,
        _AkapzToken,
        _AkapzGovernanceToken,
        _AkapzFarmingLPToken,
        _uniswapV2Factory,
        _uniswapV2Router02);
};