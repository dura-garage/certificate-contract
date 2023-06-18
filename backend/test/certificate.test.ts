import { ethers } from "hardhat";
import { expect } from "chai";

describe("Certificate", function () {

    //check the owner of the contract after deployment
    it("Should return the owner of the contract", async function () {
        const Certificate = await ethers.getContractFactory("certificate");
        const certificate = await Certificate.deploy();
        await certificate.deployed();
        expect(await certificate.owner()).to.equal(await ethers.provider.getSigner().getAddress());
    }
    );
});
       
