import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import {MIN_DELAY} from "../data/params";

const deployTimeLock: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { deploy, log } = deployments
    // @ts-ignore
    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0].address;
    log("----------------------------------------------------")
    log("Deploying TimeLock and waiting for confirmations...")
    const timeLock = await deploy("TimeLock", {
        from: deployer,
        args: [MIN_DELAY, [], []],
        log: true,
        // we need to wait if on a live network so we can verify properly
        waitConfirmations:  1,
    });
    // @ts-ignore
    await hre.ethernal.push({
        name: 'TimeLock',
        address: timeLock.address
    });
    log(`TimeLock at ${timeLock.address}`)

}

export default deployTimeLock
deployTimeLock.tags = ["all", "timelock"]