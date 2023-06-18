
import { HardhatUserConfig, task } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "@nomiclabs/hardhat-ethers";
import "@typechain/hardhat";
import "hardhat-deploy";
import { docgen } from "solidity-docgen";

const config: HardhatUserConfig = {
  solidity: "0.8.18",
  defaultNetwork: "hardhat",
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  networks: {
    hardhat: {
      chainId: 1337,
    },
  },
  paths: {
    artifacts: "./artifacts",
    cache: "./cache",
    sources: "./contracts",
    tests: "./test",
  },

  // docgen: {
  //   path: "./docs",
  //   clear: true,
  //   runOnCompile: true,
  // },

  // Add the deploy script to the hardhat.config.js file
  // Make sure to adjust the path if needed
  // and define any necessary network configurations
  // for deploying to specific networks
  // ...
};

export default config;