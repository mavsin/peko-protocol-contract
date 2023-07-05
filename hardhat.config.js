require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const { API_KEY, WALLET_PRIVATE_KEY, RPC_URL } = process.env;

task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: '0.8.10',
    settings: {
      optimizer: {
        enabled: true,
        runs: 100000,
      },
      evmVersion: 'london',
    },
  },
  defaultNetwork: 'lineaGoerli',
  networks: {
    lineaGoerli: {
      url: RPC_URL,
      accounts: [WALLET_PRIVATE_KEY]
    }
  },
  etherscan: {
    apiKey: API_KEY,
  },
};
