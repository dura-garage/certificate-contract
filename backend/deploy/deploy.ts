const fs = require('fs-extra')
import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction, DeployResult, DeploymentsExtension } from 'hardhat-deploy/types'
import { artifacts, ethers } from "hardhat";
import { log } from "console";

declare module "hardhat/types" {
    interface HardhatRuntimeEnvironment {
        ethers: typeof ethers;
        getNamedAccounts: () => Promise<{ [name: string]: string }>;
        deployments: DeploymentsExtension;
    }
}

const deployFunction: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
    const { deployments, getNamedAccounts } = hre;
    const { deploy } = deployments;

    // Get the deployer's address
    const { deployer } = await getNamedAccounts();


    // Deploy the CertificateContract
    const contractResponse = await deploy("CertificateContract", {
        from: deployer,
        log: true,
        deterministicDeployment: false,
    });
    log("Deploying Contract!...")
    console.log(contractResponse.address);
    log("----------------------");
    log("Saving to Frontend!")
    await saveFrontendFiles(contractResponse);
}
async function saveFrontendFiles(certi: DeployResult) {
    const contractsDir = __dirname + "/../../frontend/src/abi";
    // Ensure directory exists, if not, create it
    fs.ensureDirSync(contractsDir);
    fs.outputJSONSync(
        contractsDir + "/contract-address.json",
        { Certificate: certi.address }
    );

    const CertificateArtifact = await artifacts.readArtifact("CertificateContract");
    console.log(CertificateArtifact);
    fs.outputJSONSync(
        contractsDir + "/Certificate.json",
        CertificateArtifact
    )
}
export default deployFunction;
module.exports.tags = ["all", "local"]