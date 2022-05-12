import { HardhatRuntimeEnvironment } from "hardhat/types"

import { ethers } from "hardhat"
import {DeployFunction} from "hardhat-deploy/types";
import {ADDRESS_ZERO} from "../data/params";

const setupContracts: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    const { getNamedAccounts, deployments, network } = hre
    const { log } = deployments
    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0]

    let akapzInstance = await hre.deployments.get("Akapz");
    const tokenAddr = akapzInstance.address;
    let tl = await hre.deployments.get("TimeLock");
    const timeLockAddr = tl.address;
    let gi = await hre.deployments.get("GovernorContract");
    const govAddr = gi.address;
    const governanceToken = await ethers.getContractAt("Akapz", tokenAddr, deployer);
    const timeLock = await ethers.getContractAt("TimeLock", timeLockAddr, deployer)
    const governor = await ethers.getContractAt("GovernorContract", govAddr, deployer)

    log("----------------------------------------------------")
    log("Setting up contracts for roles...")
    // would be great to use multicall here...
    const proposerRole = await timeLock.PROPOSER_ROLE()
    const executorRole = await timeLock.EXECUTOR_ROLE()
    const adminRole = await timeLock.TIMELOCK_ADMIN_ROLE()

    const proposerTx = await timeLock.grantRole(proposerRole, governor.address)
    await proposerTx.wait(1)
    const executorTx = await timeLock.grantRole(executorRole, ADDRESS_ZERO)
    await executorTx.wait(1)
    const revokeTx = await timeLock.revokeRole(adminRole, deployer.address)
    await revokeTx.wait(1)
    // Guess what? Now, anything the timelock wants to do has to go through the governance process!
}

export default setupContracts
setupContracts.tags = ["all", "setup"]