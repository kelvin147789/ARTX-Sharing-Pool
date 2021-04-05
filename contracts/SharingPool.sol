// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ARTXToken.sol';



contract SharingPool {

  constructor(address _address) public {
    artxAddress = _address;
  }

  

  using SafeMath for uint256;

  address public dev = msg.sender;
  address public artxAddress;
  uint256 public totalDepositAmount;
  

  mapping(address => UserInfo) public userInfo;

  struct UserInfo {
    uint256 depositAmount;
    uint256 rewardDiv; 
    uint256 claimedReward;
  }
  

  function returnARTXAddress() public view returns(address){
    return artxAddress;
  }

  function setArtxAddress(address _address) public {
    require(msg.sender == dev,"only dev can cahnge");
    artxAddress = _address;
  }

  function  getARTXBalance(address _address) public view returns(uint256){
    ARTXToken artx = ARTXToken(artxAddress);
    return artx.balanceOf(_address);
  }

  function approveARTX(uint256 _amount) public {

  }

  function returnContractARTX() public view returns(uint256){
    return getARTXBalance(address(this));
  }

  


 

    
  }




  
