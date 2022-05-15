import * as dotenv from "dotenv";

import { HardhatUserConfig, task } from "hardhat/config";
import "@nomiclabs/hardhat-etherscan";
import "@nomiclabs/hardhat-waffle";
import "@typechain/hardhat";

import "hardhat-gas-reporter";

import * as config1 from "./data/params";

import EventEmitter from "events";
import {ethers} from "hardhat";

dotenv.config();
const emitter = new EventEmitter()
emitter.setMaxListeners(100)





// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more
// @ts-ignore

// @ts-ignore

const config: HardhatUserConfig = {
  defaultNetwork: "hardhat",
  solidity: {
    version: "0.8.9",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
      hardhat: {
      },
    mumbai: {
      url: process.env.POLYGON_URL,
      // @ts-ignore
      accounts: [process.env.PRIVATE_KEY],
      timeout: 200000,
      gasPrice: "auto",
      from: "0xc956BbcA545e0071Edcd14AE0531F7fa94D33771",
      gas: "auto",
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


};

export default config;
