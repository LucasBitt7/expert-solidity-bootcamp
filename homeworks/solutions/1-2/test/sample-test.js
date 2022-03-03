const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("DogCoin", function () {
  it("Should deploy and check name and symbol", async function () {
    const DogCoin = await ethers.getContractFactory("DogCoin");
    const dog = await DogCoin.deploy();
    await dog.deployed();

    expect(await dog.symbol()).to.equal("DC");
    expect(await dog.name()).to.equal("DogCoin");
  });
  it("should mint some tokens and send", async function() {
    const DogCoin = await ethers.getContractFactory("DogCoin");
    const dog = await DogCoin.deploy();
    await dog.deployed();

    const accounts = await ethers.getSigners();
    const account = accounts[0];

    await dog.mint(100);
    expect(await dog.balanceOf(account.address)).to.equal("100");
    // await dog.send(accounts[1].address, 50);
    // expect(await dog.balanceOf(account.address)).to.equal("50");
    // expect(await dog.balanceOf(accounts[1].address)).to.equal("50");
  })
});
