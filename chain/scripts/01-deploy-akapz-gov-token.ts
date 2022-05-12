
// @ts-ignore
import { ethers, ethernal } from "hardhat"
import * as config from "../data/params";


 const main = async function()  {
    await  ethernal.resetWorkspace("akapz")



    // @ts-ignore
    const accounts = await ethers.getSigners()
    const deployer = accounts[0].address;

    const Akapz = await ethers.getContractFactory("Akapz");
    const akapz = await Akapz.deploy(
        config.TestParams.Token.name, config.TestParams.Token.symbol, deployer
    );
    const name = await akapz.name();
    ethernal.push({name:name, address: akapz.address}).then(() => {


       akapz.delegate(deployer).then((r) => {
           console.log(`Checkpoints: ${akapz.numCheckpoints(deployer)}`)
       })




        console.log(`Delegating to ${deployer}`)

        console.log("Delegated!")
    })










}



main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
