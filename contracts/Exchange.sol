// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "./Reserve.sol";
import "./TestToken.sol";

contract Exchange {
    
    address nativeToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address contractAddr = address(this);
    TestToken token;
    mapping (address => Reserve) reserves;
    mapping (address => bool) reserved;
    uint fixedUnit = 10**18;

    constructor(){
        reserved[nativeToken] = true;
    }

    function addReserve(address _reserve, address _token) public {
        
        require(!reserved[_token]);
        Reserve reserve = Reserve(_reserve);
        reserves[_token] = reserve;
        reserved[_token] = true;
        
    }
   
    function getExchangeRate(address srcToken, address destToken, uint _amount)public view returns(uint) {
        require(_amount > 0);
        require(reserved[srcToken] && reserved[destToken]);
        if(srcToken == nativeToken) {
            return reserves[destToken].getTokenRate(_amount);
        } else if (destToken == nativeToken) {
            return reserves[srcToken].getEthRate(_amount);
        } else {
            return reserves[destToken].getTokenRate(_amount);
        }
    }

    function exchange(address srcToken , address destToken, uint _amount) payable public {
        require(_amount > 0);
        require(reserved[srcToken] && reserved[destToken]);
        
        if(srcToken == nativeToken) {
            require(msg.value == _amount);
            reserves[destToken].exchange{value: _amount}(true, _amount, msg.sender);
             
        } else if (destToken == nativeToken) {
            reserves[srcToken].exchange(false, _amount, msg.sender);    
        } else {
            token = TestToken(srcToken);
            token.transferFrom(msg.sender, reserves[srcToken].contractAddr(), _amount);
            reserves[destToken].tokenSwap(_amount, msg.sender);
        }
    }
}