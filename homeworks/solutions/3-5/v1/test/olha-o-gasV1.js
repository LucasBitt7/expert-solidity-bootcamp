// const { expect } = require("chai");
// const { ethers } = require("hardhat");

// describe("Foundation", function () {
//   before(async () => {
//     [owner, addr1, addr2, addr3] = await ethers.getSigners();
//   });

//   it("deploy", async function () {
//     const foundation = await ethers.getContractFactory("Foundation");
//     const foundationInstance = await foundation.deploy();
//     await foundationInstance.deployed();


//     await foundationInstance.connect(owner).init("some project", "some description");
//     expect(await foundationInstance.owner()).to.equal(owner.address);
//     expect(await foundationInstance.name()).to.equal("some project");
//     expect(await foundationInstance.getProposalDescription()).to.equal("some description");

//     await foundationInstance.setTime(4444);
//     await foundationInstance.connect(addr1).votePropose(true);
//     await foundationInstance.connect(addr2).votePropose(false);
//     await foundationInstance.connect(addr3).votePropose(true);
//     expect(await foundationInstance.getProposalVotesFor()).to.equal(2);

//     await foundationInstance.connect(owner).closeProposal()
//     const propose = await foundationInstance.getProposal()
//     console.log( propose.toString())



//   });
// });