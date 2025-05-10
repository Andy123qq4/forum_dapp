// forum_dapp/hardhat.config.js
require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.19", // Ensure this matches your contract's pragma
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  paths: {
    sources: "./contracts",
    tests: "./tests",
    cache: "./cache",
    artifacts: "./artifacts"
  },
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      // Local development network configuration
    },
    // Example for a testnet like Sepolia (optional)
    // sepolia: {
    //   url: process.env.SEPOLIA_RPC_URL || "YOUR_SEPOLIA_RPC_URL",
    //   accounts: process.env.PRIVATE_KEY ? [process.env.PRIVATE_KEY] : []
    // }
  }
}; 