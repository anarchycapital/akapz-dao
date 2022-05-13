import { HardhatRuntimeEnvironment } from "hardhat/types"
import {MIN_DELAY} from "../data/params";
import * as hre from "hardhat";
import * as config from "../data/params";

const main = async function()  {
    // @ts-ignore

    // @ts-ignore
    const accounts = await hre.ethers.getSigners()
    const deployer = accounts[0].address;
    console.log("----------------------------------------------------")
    console.log("Deploying TimeLock and waiting for confirmations...")
    const TimeLock = await hre.ethers.getContractFactory("TimeLock");
    const timelock = await TimeLock.deploy(MIN_DELAY, [], []);
    await timelock.deployed();

    await timelock.deployTransaction.wait(5);

    await hre.run("verify:verify", {
        address: timelock.address,
        constructorArguments: [
            MIN_DELAY, [], []
        ],
        contract: "contracts/Base/Timelock.sol:TimeLock"
    });


    console.log(`TimeLock at ${timelock.address}`)

}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
