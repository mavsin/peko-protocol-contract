const hre = require("hardhat");

async function main() {
  const deployment = await hre.ethers.deployContract("BridgeLogic");

  await deployment.waitForDeployment();

  console.log(
    `Contract has been deployed to ${deployment.target}`
  );
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
