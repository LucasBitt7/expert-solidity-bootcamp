const { ethers, upgrades } = require("hardhat");

async function deployContract() {
  const DogCoinV1 = await ethers.getContractFactory('DogCoin');

  const contract = await upgrades.deployProxy(DogCoinV1, { kind: 'uups', initializer: 'initialize'});


  await contract.deployed();

  console.log("contract addr:", contract.address);
}

deployContract()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });