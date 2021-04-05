// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";





contract ARTXSharingPool {



  /* 

  TODO: 
  - call function from deploted contract basic testing
    - https://trello.com/c/qj0LGoV3/209-call-function-of-other-contract

  - function to check the balance of ARTX in this address  , which would be sub totalDepositAmount;
  https://etherscan.io/address/0x741b0428efdf4372a8df6fb54b018db5e5ab7710#code ARTXToken 
  - Mock ARTX token for testing function
  - Deploy in Testnet

  
  
  */

 using SafeMath for uint256;



  address public artxAddress;
  ERC20 public artxContract;
  address public owner = msg.sender;
  mapping(address=> uint256) public balances;
  mapping(address => UserInfo) public userInfo;
  uint256 public rewardAmount;

  

  struct UserInfo {
    address userAddress;
    uint256 depositAmount; 
    uint256 rewardDiv;
    uint256 claimedReward;
   
  }
  


  uint256 public totalDepositAmount;


  constructor (address _erc20Address) public {
    
    artxAddress = _erc20Address;
    ERC20 artxContract = ERC20(_erc20Address);
  } 


  // DEV


  receive() external payable {
    // Send ETH to this contract for supporting dev
    // Thank you for your support !
  
  }

   function devDonateithdraw(uint256 _amount) public {
    // Disclaimer: this function only to withdraw ETH donation in the contract, NOT ARTX.Your ARTX is SAFE
    require(msg.sender == owner, "only dev can get donation");
    msg.sender.transfer(_amount);
  }

  // DEV 

  

  function returnContractARTX() public view returns (uint256) {
    return artxContract.balanceOf(address(this));
  }

  function returnARTXbalance() public view returns (uint256) {
    return artxContract.balanceOf(msg.sender);
  }

   function returnTotalRewardAmount() public view returns (uint256) {
    uint256 rewardAmounts; 
    rewardAmounts = artxContract.balanceOf(address(this)).sub(totalDepositAmount);
    return rewardAmounts;
  }



 


  function changeOwnership(address _newDev) public {
    require(msg.sender ==owner, "only dev can change owner");
    owner = _newDev;

  }


 

  

   function returnDepositAmount() public view returns (uint256) {
     return userInfo[msg.sender].depositAmount;
   }

    function returnTotalDepositAmount() public view returns (uint256) {
     return totalDepositAmount;
   }

  


  
    


  function depositARTX (uint256 _depositAmount) public returns (bool){
    UserInfo storage user = userInfo[msg.sender];
    require(_depositAmount > 0 , "No amount of ARTX is deposited");
     user.userAddress = msg.sender;
     user.rewardDiv =  balances[msg.sender].div(totalDepositAmount);
     user.depositAmount = _depositAmount.add(_depositAmount);
    totalDepositAmount.add(_depositAmount);
    artxContract.transferFrom(msg.sender,address(this),_depositAmount);
    // Check if new users
    return true;
  }
 

  function claimReward() public  returns (uint256) {
    UserInfo storage user = userInfo[msg.sender];
    uint256 totalReward = returnTotalRewardAmount();
    uint256 userRewardDiv = user.rewardDiv;
    uint256 userClaimed = user.claimedReward;
    uint256 userClaimAmount = totalReward.mul(userRewardDiv).sub(userClaimed);
    user.claimedReward = user.claimedReward.add(userClaimAmount);
    require(userClaimAmount > 0 , "No remaining amount of claimedReward");
    artxContract.transfer(msg.sender,userClaimAmount);
    return userClaimAmount;
  }

  function withdraw() public returns (uint256) {
    UserInfo storage user = userInfo[msg.sender];
    uint256 withdrawAmount = user.depositAmount;
    require(withdrawAmount > 0 ,"NO remaining depositAmount");
     user.depositAmount = 0;
    artxContract.transfer(msg.sender,withdrawAmount);
  }


  

  
  

  

  
}
