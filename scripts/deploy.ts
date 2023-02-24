import { ethers } from "hardhat";

async function main() {
  // const [deployer] = await ethers.getSigners();

  const EVote = await ethers.getContractFactory("EVote");
  const deployed_EVote = await EVote.deploy();
  await deployed_EVote.deployed();
  console.log(deployed_EVote.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
