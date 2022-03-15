const { ethers, upgrades } = require("hardhat");

const V1_PROXY_ADDRESS = '0x16D21683feAb7dAa65D5B4fd906bE8a81eF589F8';
const V1_ADDRESS = "0x1d21c6B83f87117044C93fC4d3b046Db6caBd342";

async function deployContract() {

  const DogCoinV2 = await ethers.getContractFactory("DogCoinV2");

  const upgraded = await upgrades.upgradeProxy(V1_PROXY_ADDRESS, DogCoinV2); 
  console.log("contract addr:", upgraded.address);
}

deployContract()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });