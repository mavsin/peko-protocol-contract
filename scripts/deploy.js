const hre = require("hardhat");

async function main() {
  const deployment = await hre.ethers.deployContract("Pool", ["0x833FdD1c0A7A7d03c913C90E110D63b7c54b8a73"], {
    libraries: {
      BorrowLogic: "0xa845dbA0A5A2357275d6788bD417dC62c1d36D12",
      BridgeLogic: "0x909F189Db0B0C07792D95589424c3b1137568Bfd",
      EModeLogic: "0xBea8F4EE1e963F2C901920348A01839517b3c772",
      LiquidationLogic: "0x378fff636d8848EC64e9150cE96f48470b30980c",
      PoolLogic: "0xAD639a4fa13737FA28cD101798e27AA616Aa866b",
      SupplyLogic: "0x8d1e7d9841607ECa05C113fa0746874F096225B3"
    }
  });

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
