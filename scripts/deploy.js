// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");
// import {getPoolAddressesProvider} from '@aave/deploy-v3';

// describe('Tests', () => {
//   before(async () => {
//      // Set the MARKET_NAME env var
//      process.env.MARKET_NAME = "Peko"

//      // Deploy Aave V3 contracts before running tests
//      await hre.deployments.fixture(['market', 'periphery-post']);
//   })

//   it('Get Pool address from AddressesProvider', async () => {
//      const addressesProvider = await getPoolAddressesProvider();

//      const poolAddress = await addressesProvider.getPool();

//      console.log('Pool', poolAddress);
//   })
// })

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const unlockTime = currentTimestampInSeconds + 60;

  // const lockedAmount = hre.ethers.parseEther("0.001");

  // const contractFactory = await hre.ethers.getContractFactory("Pool", {
  //   libraries: {
  //     BorrowLogic: "0x99De5245d305b629d32acf25DA49344c2c81a8E5",
  //     BridgeLogic: "0x4f9c58803720d94331e67B90b1145c42aA6AB825",
  //     EModeLogic: "0x0412796a45F577E2A9da002Db44C3373660E799D",
  //     LiquidationLogic: "0xc6b6a36d31A50159f32065606E3be78981a30C22",
  //     PoolLogic: "0x9F2b859147B69F3eed49025e5D805Bc22a94A176",
  //     SupplyLogic: "0xBA3442dbE0E526E1a5E316d9fd17ccD59b8e0C6B"
  //   }
  // });
  // const contract = await contractFactory.deploy("0x73F238bf2f94D5a72fbB127adc33501d96C3B890");
  // // Wait for this transaction to be mined
  // await contract.deployed()

  // // Get contract address
  // console.log("Contract deployed to:", contract.address);

  const deployment = await hre.ethers.deployContract("Pool", ["0x73F238bf2f94D5a72fbB127adc33501d96C3B890"], {
    libraries: {
      BorrowLogic: "0x99De5245d305b629d32acf25DA49344c2c81a8E5",
      BridgeLogic: "0x4f9c58803720d94331e67B90b1145c42aA6AB825",
      EModeLogic: "0x0412796a45F577E2A9da002Db44C3373660E799D",
      LiquidationLogic: "0xc6b6a36d31A50159f32065606E3be78981a30C22",
      PoolLogic: "0x9F2b859147B69F3eed49025e5D805Bc22a94A176",
      SupplyLogic: "0xBA3442dbE0E526E1a5E316d9fd17ccD59b8e0C6B"
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
