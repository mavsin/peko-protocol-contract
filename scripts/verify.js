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
  await hre.run("verify:verify", {
    address: "0xc3e747214C511E67eEA9934128cDb8E70FcDE4EA",
    constructorArguments: [
      "0x73F238bf2f94D5a72fbB127adc33501d96C3B890"
    ],
  });
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
