// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;
import "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract TestToken is ERC20{
  constructor() ERC20("SwapTestToken ", "STT"){
    _mint(msg.sender, 1000000*10**18);
  }
   
}
