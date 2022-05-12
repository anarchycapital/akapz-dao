import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import {QUORUM_PERCENTAGE, VOTING_DELAY, VOTING_PERIOD} from "../data/params";

const deployGovernorContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log, get } = deployments
    // @ts-ignore
    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0].address;
    const governanceToken = await get("Akapz")
    const timeLock = await get("TimeLock")

    log("----------------------------------------------------")
    log("Deploying GovernorContract and waiting for confirmations...")
    const governorContract = await deploy("GovernorContract", {
        from: deployer,
        args: [
            governanceToken.address,
            timeLock.address,
            QUORUM_PERCENTAGE,
            VOTING_PERIOD,
            VOTING_DELAY,
        ],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations:  1,
    });
    // @ts-ignore
    await hre.ethernal.push({
        name: 'GovernorContract',
        address: governorContract.address
    });
    log(`GovernorContract at ${governorContract.address}`)

}

export default deployGovernorContract
deployGovernorContract.tags = ["all", "governor"]