const hre = require("hardhat");

async function main() {
  const Foundation = await hre.ethers.getContractFactory("Factory");

  const foundation = await Foundation.deploy();

  await foundation.deployed();

  console.log("Template deployed to:", foundation.address);

  await hre.run(`verify ${foundation.address}`);

  // const ClonePattern = await hre.ethers.getContractFactory("Factory");
  // const clonePattern = await ClonePattern.deploy();

  // await clonePattern.deployed();

  // console.log("Factory deployed to:", clonePattern.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
