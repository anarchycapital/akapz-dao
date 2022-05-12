import { HardhatRuntimeEnvironment } from "hardhat/types"

// @ts-ignore
import { ethers } from "hardhat"
import * as config from "../data/params";


const deployAkapzGovToken = async function (hre: HardhatRuntimeEnvironment) {
    // @ts-ignore
    hre.tracer.enabled = true;
    // @ts-ignore
    const { getNamedAccounts, network } = hre


    // @ts-ignore
    const accounts = await ethers.getSigners()
    const deployer = accounts[0].address;

    const Akapz = await ethers.getContractFactory("Akapz");
    const akapz = await Akapz.deploy(
        config.TestParams.Token.name, config.TestParams.Token.symbol, deployer
    );

   await akapz.deployed()




    console.log(`Delegating to ${deployer}`)
    await delegate(akapz.address, deployer)
    console.log("Delegated!")
    try {
        const instance = await ethers.getContract("Akapz", deployer);

        // @ts-ignore
        await hre.ethernal.push({
            name: "Akapz",
            address: instance.address
        });
    } catch(err) {
        console.error(err);
    }

}

const delegate = async (governanceTokenAddress: string, delegatedAccount: string) => {
    const governanceToken = await ethers.getContractAt("Akapz", governanceTokenAddress)
    const transactionResponse = await governanceToken.delegate(delegatedAccount)
    await transactionResponse.wait(1)
    console.log(`Checkpoints: ${await governanceToken.numCheckpoints(delegatedAccount)}`)
}

export default deployAkapzGovToken;
deployAkapzGovToken.tags = ["all", "governor"];