import { HardhatRuntimeEnvironment } from "hardhat/types"

import { ethers } from "hardhat"
import {ADDRESS_ZERO} from "../data/params";


import * as hre from "hardhat";
import * as config from "../data/params";

const main = async function() {

    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0]

    const governanceToken = await ethers.getContractAt("Akapz", config.DEV_AKAPZ_TOKEN, deployer);
    const timeLock = await ethers.getContractAt("TimeLock", config.DEV_TIMELOCK, deployer);
    const governor = await ethers.getContractAt("GovernorContract", config.DEV_GOVERNOR, deployer);

    console.log("----------------------------------------------------")
    console.log("Setting up contracts for roles...")
    // would be great to use multicall here...
    const proposerRole = await timeLock.PROPOSER_ROLE()
    const executorRole = await timeLock.EXECUTOR_ROLE()
    const adminRole = await timeLock.TIMELOCK_ADMIN_ROLE()

    const proposerTx = await timeLock.grantRole(proposerRole, config.DEV_GOVERNOR)
    await proposerTx.wait(1)
    const executorTx = await timeLock.grantRole(executorRole, ADDRESS_ZERO)
    await executorTx.wait(1)
    const revokeTx = await timeLock.revokeRole(adminRole, deployer.address)
    await revokeTx.wait(1)
    // Guess what? Now, anything the timelock wants to do has to go through the governance process!
}
main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
