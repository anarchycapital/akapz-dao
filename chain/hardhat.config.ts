import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";
import "hardhat-ethernal";
import "hardhat-gas-reporter";

import * as config1 from "./data/params";

import EventEmitter from "events";
import {ethernal, ethers} from "hardhat";

dotenv.config();
const emitter = new EventEmitter()
emitter.setMaxListeners(100)



task("deployme", "deploy hardhat", async (taskArgs, hre) =>  {



  // @ts-ignore
  const account = await hre.ethers.getSigners()
  const deployer = account[0].address;

  const Akapz = await hre.ethers.getContractFactory("Akapz");
  const akapz = await Akapz.deploy(
      config1.TestParams.Token.name, config1.TestParams.Token.symbol, deployer
  );
  const name = await akapz.name();

  await akapz.delegate(deployer)

  await hre.ethernal.push({name:name, address: akapz.address})







    console.log(`Delegating to ${deployer}`)

    console.log("Delegated!")

})

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
// @ts-ignore

// @ts-ignore
const config: HardhatUserConfig = {
  solidity: "0.8.9",
  defaultNetwork: "hardhat",
  networks: {
      hardhat: {
      },
    ropsten: {
      url: process.env.ROPSTEN_URL || "",
      accounts:
        process.env.PRIVATE_KEY !== undefined ? [process.env.PRIVATE_KEY] : [],
    },
  },
  gasReporter: {
    enabled: process.env.REPORT_GAS !== undefined,
    currency: "USD",
  },
  etherscan: {
    apiKey: process.env.ETHERSCAN_API_KEY,
  },
  // @ts-ignore
  ethernal: {
    email: process.env.ETHERNAL_EMAIL,
    password: process.env.ETHERNAL_PASSWORD,
    uploadAst: true, // If set to true, plugin will upload AST, and you'll be able to use the storage feature (longer sync time though)

  }

};

export default config;
