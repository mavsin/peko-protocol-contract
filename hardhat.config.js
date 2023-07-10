require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config();

const { API_KEY, MAINNET_RPC_URL, RPC_URL, WALLET_PRIVATE_KEY } = process.env;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    compilers: [
      {
        version: "0.8.10",
        settings: {
          optimizer: { enabled: true, runs: 100_000 },
          evmVersion: "berlin"
        }
      },
    ]
  },
  external: {
    contracts: [
      {
        artifacts: 'node_modules/@aave/deploy-v3/artifacts',
        deploy: 'node_modules/@aave/deploy-v3/dist/deploy',
      },
    ],
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
  }
};
