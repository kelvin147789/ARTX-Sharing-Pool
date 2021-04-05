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
  uint256 public basicPoint10000x = 1850000;
  
  

  mapping(address => UserInfo) public userInfo;

  struct UserInfo {
    uint256 depositAmount;
    uint256 rewardDiv; 
    uint256 claimedReward;
  }

  
  receive() external payable {
    // Send ETH to this contract for supporting dev
    // Thank you for your support !
  }

  function devDonateithdraw(uint256 _amount) public {
    // Disclaimer: this function only to withdraw ETH donation in the contract, NOT ARTX.Your ARTX is SAFE
    require(msg.sender == dev, "only dev can get donation");
    msg.sender.transfer(_amount);
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

  //  function allowance(address _owner,address _spender) external view returns(uint256) {
  //   ARTXToken artx = ARTXToken(artxAddress);
  //   artx.allowance(_owner,_spender);
  // }
  
  // This need toe be manually approve
  // function approveARTX(address _spender , uint256 _amount) external {
  //   ARTXToken artx = ARTXToken(artxAddress);
  //   artx.approve(_spender,_amount);
  // }

  function deposit( uint256 _amount) public returns (bool){
    // Mannually Approve this address to spend ARTX , then call this function
    UserInfo storage user = userInfo[msg.sender];
    ARTXToken artx = ARTXToken(artxAddress);
    user.depositAmount = user.depositAmount.add(_amount);
    totalDepositAmount = totalDepositAmount.add(_amount);
    user.rewardDiv = user.depositAmount.mul(basicPoint10000x).div(totalDepositAmount);
    // Would div basicPoint100x when claim Reward
    artx.transferFrom(msg.sender,address(this),_amount);
    return true;
  }

   function returnTotalReward () public view returns (uint256) {
     return getARTXBalance(address(this)).sub(totalDepositAmount);
    }

  

 

  


 

    
  }




  
