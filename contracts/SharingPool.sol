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
  

  function returnARTXAddress() external view returns(address){
    return artxAddress;
  }

  function setArtxAddress(address _address) external {
    require(msg.sender == dev,"only dev can cahnge");
    artxAddress = _address;
  }

  function  getARTXBalance(address _address) public view returns(uint256){
    ARTXToken artx = ARTXToken(artxAddress);
    return artx.balanceOf(_address);
  }

  function returnContractARTX() public view returns(uint256){
    return getARTXBalance(address(this));
  }

   function allowance(address _owner,address _spender) external view returns(uint256) {
    ARTXToken artx = ARTXToken(artxAddress);
    artx.allowance(_owner,_spender);
  }
  
  // This need toe be manually approve
  // function approveARTX(address _spender , uint256 _amount) external {
  //   ARTXToken artx = ARTXToken(artxAddress);
  //   artx.approve(_spender,_amount);
  // }

  function deposit( uint256 _amount) public returns (bool){
    UserInfo storage user = userInfo[msg.sender];
    ARTXToken artx = ARTXToken(artxAddress);
    user.depositAmount = user.depositAmount.add(_amount);
    totalDepositAmount.add(_amount);
    user.rewardDiv = user.depositAmount.div(totalDepositAmount);
    artx.transferFrom(msg.sender,address(this),_amount);
    return true;
  }

 

  


 

    
  }




  
