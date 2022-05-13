
// @ts-ignore
import { ethers} from "hardhat"
import * as hre from "hardhat";
import * as config from "../data/params";


 const main = async function()  {

    // @ts-ignore
    const accounts = await ethers.getSigners()
    const deployer = accounts[0].address;

    const Akapz = await ethers.getContractFactory("Akapz");
    const akapz = await Akapz.deploy(
        config.TestParams.Token.name, config.TestParams.Token.symbol, deployer
    );
    await akapz.deployed();
    await akapz.deployTransaction.wait(5);

    await hre.run("verify:verify", {
        address: akapz.address,
        constructorArguments: [
            config.TestParams.Token.name, config.TestParams.Token.symbol, deployer
        ]
    });
   /* ethernal.push({name:name, address: akapz.address}).then(() => {*/

     console.log(`Delegating to ${deployer}`)
       await akapz.delegate(deployer)






        console.log("Delegated!")
   // })


}



main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
