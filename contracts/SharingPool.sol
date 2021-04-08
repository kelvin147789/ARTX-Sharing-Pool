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
  uint256 public latestID = 0;
  
  

  mapping(address => UserInfo) public userInfo;
  address[] public users;

  struct UserInfo {
    uint256 depositAmount;
    uint256 nextClaimTime;
    uint256 rewardDiv;
    uint256 userID;

  }

  function changeDev(address _address) public {
    require(msg.sender == dev, "only dev can change Dev");
    dev = _address;
  }
  
  function updateReward(uint256 _airdropAmount) public {
  // This need to execute every month when airdrop sent to the contract
  require(msg.sender == dev ,"only dev can updateReward");
  uint arrayLength = users.length;
  for (uint256 i = 0 ; i < arrayLength;i++)
  { 
  UserInfo storage user = userInfo[users[i]];
  // Would div basicPoint100x when claim / add reward
  uint256 addAmount = _airdropAmount.mul(user.rewardDiv).div(basicPoint10000x);
  user.depositAmount = user.depositAmount.add(addAmount);
  }
  //all airdropped ARTX is added to user's depositAmount
  totalDepositAmount = totalDepositAmount.add(_airdropAmount);
  
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
    require(msg.sender == dev,"only dev can change");
    artxAddress = _address;
  }

  function  getARTXBalance(address _address) public view returns(uint256){
    ARTXToken artx = ARTXToken(artxAddress);
    return artx.balanceOf(_address);
  }

  function returnContractARTX() public view returns(uint256){
    return getARTXBalance(address(this));
  }

 
  // This need toe be manually approve in ARTX Contract 
  // function approveARTX(address _spender , uint256 _amount) external {
  //   ARTXToken artx = ARTXToken(artxAddress);
  //   artx.approve(_spender,_amount);
  // }

  function deposit( uint256 _amount) public returns (bool){
    // Mannually Approve this address to spend ARTX , then call this function
    UserInfo storage user = userInfo[msg.sender];
    if (user.depositAmount == 0) {
    users.push(msg.sender);
    user.userID = latestID;
    latestID = latestID.add(1);
    }
    ARTXToken artx = ARTXToken(artxAddress);
    user.nextClaimTime = block.timestamp.add(31 days);
    user.depositAmount = user.depositAmount.add(_amount);
    totalDepositAmount = totalDepositAmount.add(_amount);
    user.rewardDiv = user.depositAmount.mul(basicPoint10000x).div(totalDepositAmount);
    
    artx.transferFrom(msg.sender,address(this),_amount);
    return true;
  }

   function returnTotalReward () public view returns (uint256) {
    return getARTXBalance(address(this)).sub(totalDepositAmount);
   }
   
   function remove(uint256 index) internal {
    delete users[index];
   }

    function withdrawAmount(uint256 _amount) public {
      // Right now you can claim with this function,or simply withdraw
      UserInfo storage user = userInfo[msg.sender];
      ARTXToken artx = ARTXToken(artxAddress);
      user.depositAmount = user.depositAmount.sub(_amount);
      totalDepositAmount = totalDepositAmount.sub(_amount);
      require(user.depositAmount >= 0,"Not enough token to withdraw");
      require(user.nextClaimTime > block.timestamp, "Too early to withdraw,wait 31 days after deposit");
      user.nextClaimTime = user.nextClaimTime.add(31 days);
      if (user.depositAmount == 0)
      {
      remove(user.userID) 
      }
      artx.transfer(msg.sender, _amount);
    }
     
   
   
}
  


