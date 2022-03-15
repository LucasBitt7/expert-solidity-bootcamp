const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DogCoin", function () {
  it("Should deploy and check name and symbol", async function () {
    const DogCoin = await ethers.getContractFactory("contracts/DogCoin.sol:MyToken");
    const dog = await upgrades.deployProxy(DogCoin, { kind: "uups"}); 
    await dog.deployed();

    expect(await dog.symbol()).to.equal("DC");
    expect(await dog.name()).to.equal("DogCoin");
  });
});
