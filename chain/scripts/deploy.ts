// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import * as hre from "hardhat";
import * as params from "../data/params";

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy
  const accounts = await hre.ethers.getSigners();
  const owner = accounts[0];

  const Akapz = await hre.ethers.getContractFactory("Akapz");
  const akapz = await Akapz.deploy("AkapzDao", "Akapz", owner.address);
  await akapz.deployed();

  const delegate = async (
    governanceTokenAddress: string,
    delegatedAccount: string
  ) => {
    const governanceToken = await hre.ethers.getContractAt(
      "Akapz",
      governanceTokenAddress
    );
    const transactionResponse = await governanceToken.delegate(
      delegatedAccount
    );
    await transactionResponse.wait(1);
    console.log(
      `Checkpoints: ${await governanceToken.numCheckpoints(delegatedAccount)}`
    );
  };

  await delegate(akapz.address, owner.address);

  console.log("AkapzDAO deployed to:", akapz.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
