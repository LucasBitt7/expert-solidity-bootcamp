require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-ethers");
require("hardhat-tracer");
require("solidity-coverage")

const dotenv = require('dotenv');
dotenv.config();

const DEPLOY_PRIV_KEY = process.env.DEPLOY_ACCOUNT_PRIVATE_KEY || '';

  module.exports = {
      solidity: "0.8.4",
  networks: {
    hardhat: {
      hardfork: "london",
      gasPrice: "auto",
      initialBaseFeePerGas: 1_000_000_000
    },
    tanenbaum: {
      url: 'https://rpc.tanenbaum.io/',
      gasPrice: "auto",
      hardfork: "london",
      chainId: 5700,
      accounts: [DEPLOY_PRIV_KEY]
    },
    localhost: {
      gasPrice: 470000000000,
      chainId: 43114,
      url: "http://127.0.0.1:8545/ext/bc/C/rpc"
    },

  },
  plugins: ["solidity-coverage"]
};

