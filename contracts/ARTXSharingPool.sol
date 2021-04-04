// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/math/SafeMath.sol";





contract ARTXSharingPool {



  /* 

  TODO: 
  - call function from deploted contract basic testing
    - https://trello.com/c/SxcVO0bS/208-calling-function-from-deployed-contract
    
  - function to check the balance of ARTX in this address  , which would be sub totalDepositAmount;
  https://etherscan.io/address/0x741b0428efdf4372a8df6fb54b018db5e5ab7710#code ARTXToken 
  - Mock ARTX token for testing function
  - Deploy in Testnet

  
  
  */

 using SafeMath for uint256;

 event Transfer(address indexed from, address indexed to, uint256 tokens);
 event Burn(address indexed burner, uint256 value);
 event Approval(address indexed tokenOwner, address indexed spender, uint256 tokens);


  ERC20 public artx;
  address public owner = msg.sender;
  mapping(address=> uint256) public balances;
  mapping(address => mapping (address => uint256)) allowed;
  mapping(address => UserInfo) public userInfo;
  uint256 public rewardAmount;
  


  struct UserInfo {
    address userAddress;
    uint256 depositAmount; 
    uint256 rewardDiv;
    uint256 claimedReward;
   
  }
  


  uint256 public totalDepositAmount;


  constructor (ERC20 _token) public {
    artx = ERC20(_token);
  } 


  function returnTotalRewardAmount() public view returns (uint256) {
    uint256 rewardAmounts; 
    rewardAmounts = artx.balanceOf(address(this)).sub(totalDepositAmount);
    return rewardAmounts;
   
  }

  function allowance(address _owner, address delegate) public view returns (uint256) {
       return allowed[_owner][delegate];
   }

   function returnDepositAmount() public view returns (uint256) {
     return balances[msg.sender];
   }

    function returnTotalDepositAmount() public view returns (uint256) {
     return totalDepositAmount;
   }

  


   function approve(address delegate, uint256 numTokens) public returns (bool) {
       allowed[msg.sender][delegate] = numTokens;
       emit Approval(msg.sender, delegate, numTokens);
       return true;
   }

    function transferFrom(address _owner, address buyer, uint256 numTokens) public returns (bool) {
       require(numTokens <= balances[_owner],"num exceeds");   
       require(numTokens <= allowed[_owner][msg.sender],"allowance exceeds");
       balances[_owner] = balances[_owner]-= numTokens;
       allowed[_owner][msg.sender] = allowed[_owner][msg.sender] -= numTokens;
       balances[buyer] = balances[buyer] += numTokens;
       emit Transfer(_owner, buyer, numTokens);
       return true;
   }


  function depositARTX (uint256 _depositAmount) public returns (bool){
    UserInfo storage user = userInfo[msg.sender];
    require(_depositAmount > 0 , "No amount of ARTX is deposited");
     user.userAddress = msg.sender;
     user.rewardDiv =  balances[msg.sender].div(totalDepositAmount);
     user.depositAmount = _depositAmount.add(_depositAmount);
    totalDepositAmount.add(_depositAmount);
    artx.transferFrom(msg.sender,address(this),_depositAmount);
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
    artx.transfer(msg.sender,userClaimAmount);
  }


  

  
  

  

  
}
