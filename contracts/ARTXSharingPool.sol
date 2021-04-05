// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import './ARTXToken.sol';



contract ARTXSharingPool1 {

  address artxAddress; 

  function returnARTXAddress() public view returns(address){
    return artxAddress;
  }

  function setArtxAddress(address _address) public {
    artxAddress = _address;
  }

  function  callARTXBalance() public view returns(uint256){
    ARTXToken artx = ARTXToken(artxAddress);
    return artx.balanceOf(artxAddress);
  }

  function set() public view returns(uint256) {
    return 1;
  }


 

    
  }




  
