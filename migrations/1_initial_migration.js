const SharingPool = artifacts.require("SharingPool");
const ARTXToken = artifacts.require("ARTXToken");


// Deploy a mock ARTX for testing 

module.exports = async function (deployer) {

  await deployer.deploy(ARTXToken);
  // Remeber to change the address below to official ARTX address 
  await deployer.deploy(SharingPool,'0x6a30458929f8a300e9c1b4c11df195d32a79d644');
};


/*

npx truffle-flattener ./contracts/SharingPool.sol > ./contracts/FlatSharingPool.sol
npx truffle-flattener ./contracts/ARTXToken.sol > ./contracts/FlatARTXToken.sol
// ARTX:  0x6a30458929f8a300e9c1b4c11df195d32a79d644
// 6.12 single no license
// truffle migrate --reset --network bsctest

*/