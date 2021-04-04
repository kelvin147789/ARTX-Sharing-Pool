const ARTXSharingPool = artifacts.require("ARTXSharingPool");


// Deploy a mock ARTX for testing 

module.exports = async function (deployer) {
  const artxAddress = '0x741b0428efdf4372a8df6fb54b018db5e5ab7710';
  await deployer.deploy(ARTXSharingPool,artxAddress);
};
