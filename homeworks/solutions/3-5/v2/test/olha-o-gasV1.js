const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("Foundation", function () {
  before(async () => {
    [owner, addr1, addr2, addr3] = await ethers.getSigners();
  });

  it("deploy", async function () {
    const Factory = await ethers.getContractFactory("Factory");
    const factoryInstance = await Factory.deploy();
    await factoryInstance.deployed();
    expect(factoryInstance.address).to.not.be.null;

    await factoryInstance.createClone("some project", "some description", 9999);
    const clone = await factoryInstance.getCloneIndex(0);
    console.log(clone)

    const foundationInstance = await ethers.getContractAt("Factory", clone);
    expect(foundationInstance.address).to.not.be.null;

    //console.log(foundationInstance);
    // expect(await foundationInstance.getProposalName()).to.equal("some project");
    // expect(await foundationInstance.getProposalDescription()).to.equal("some description");
    // expect(await foundationInstance.getProposalTimestamp()).to.equal(9999);

    // await foundationInstance.connect(addr1).votePropose(true);
    // await foundationInstance.connect(addr2).votePropose(false);
    // await foundationInstance.connect(addr3).votePropose(true);
    // expect(await foundationInstance.getProposalVotesFor()).to.equal(2);

    // await foundationInstance.connect(owner).closeProposal()
    // const propose = await foundationInstance.getProposal()
    // console.log( propose.toString())



  });
});