import { HardhatRuntimeEnvironment } from "hardhat/types"
import { DeployFunction } from "hardhat-deploy/types"
import {QUORUM_PERCENTAGE, VOTING_DELAY, VOTING_PERIOD, DEV_AKAPZ_TOKEN, DEV_TIMELOCK, MIN_DELAY} from "../data/params";
import * as hre from "hardhat";

const main = async function()  {

    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0].address;

    console.log("----------------------------------------------------")
    console.log("Deploying GovernorContract and waiting for confirmations...")
    const GovernorContract = await hre.ethers.getContractFactory("GovernorContract");
    const gov = await GovernorContract.deploy( DEV_AKAPZ_TOKEN,
        DEV_TIMELOCK,
        QUORUM_PERCENTAGE,
        VOTING_PERIOD,
        VOTING_DELAY);

    await gov.deployed();

    await gov.deployTransaction.wait(5);

    await hre.run("verify:verify", {
        address: gov.address,
        constructorArguments: [
            DEV_AKAPZ_TOKEN,
            DEV_TIMELOCK,
            QUORUM_PERCENTAGE,
            VOTING_PERIOD,
            VOTING_DELAY
        ],
        contract: "contracts/Governance/Governor.sol:GovernorContract"
    });

        /*await deploy("GovernorContract", {
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
    });*/

    console.log(`GovernorContract at ${gov.address}`)

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
