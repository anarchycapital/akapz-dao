import { expect } from "chai";
import { ethers } from "hardhat";
import * as hre from "hardhat";
import * as params from "../data/params";
import {parseEther} from "ethers/lib/utils";

describe("VotingToken", function () {
    it("Should return the right token information when deployed", async function () {
        const accounts = await hre.ethers.getSigners();
        const owner = accounts[0];

        const Akapz = await hre.ethers.getContractFactory("Akapz");
        const akapz = await Akapz.deploy(params.TestParams.Token.name,
            params.TestParams.Token.symbol, owner.address);
        await akapz.deployed();

        const instance = await hre.ethers.getContractAt("Akapz", akapz.address);
        let name = await instance.name();
        let symbol = await instance.symbol();
        let supply = await instance.balanceOf(owner.address);
        supply = parseEther(supply.toString());
        let pSupply = parseInt("100000000000000000000000000000000000000000000");
        expect(name, "name is not the same as params!").to.equal(params.TestParams.Token.name);
        expect(parseInt(supply.toString()), "supply should be equal to " +pSupply+ " , got: "+supply+" instead").to.equal(pSupply);

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
        console.log("governance token delegates to:", owner.address);
    });
});
