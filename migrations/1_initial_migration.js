const ARTXSharingPool1 = artifacts.require("ARTXSharingPool1");
const ARTXToken = artifacts.require("ARTXToken");


// Deploy a mock ARTX for testing 

module.exports = async function (deployer) {

  // await deployer.deploy(ARTXToken);
  const artxAddress = '0x9E9f808fcFe29E90FD208fB2E7F71c49a95D91c9';
  await deployer.deploy(ARTXSharingPool1,artxAddress);
};



// npx truffle-flattener ./contracts/ARTXSharingPool1.sol > ./contracts/Flat.sol
// 6.12 single no license