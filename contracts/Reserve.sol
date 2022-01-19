// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "./TestToken.sol";

contract Reserve {
    
    address public contractAddr = address(this);

    ERC20 public token;

    uint fixedUnit = 10**18;
    uint buyRate;
    uint sellRate;

    constructor(address _token){
        token = ERC20(_token);

    }   
     
    
    function setExchangeRates(uint _buyRate, uint _sellRate) public {
        
        buyRate = _buyRate ;
        sellRate = _sellRate;
        
    }
    
    function getExchangeRate(bool isBuy, uint _amount) public view returns (uint) {
        
        if(isBuy) {
            
            if( token.balanceOf(contractAddr) >= (_amount * fixedUnit) / buyRate ) {
                
                return buyRate;
            
            }
            else return 0;
        } else {
            
            if( (_amount * sellRate) / fixedUnit <= contractAddr.balance ) {
                return sellRate;
            }
            else return 0;
        }
        
    }

    function getTokenBalance() public view returns(uint) {
        
        return token.balanceOf(contractAddr);
        
    }
    
    function getBalance() public view returns(uint) {
        
        return contractAddr.balance;
    
    }
    

    function exchange(bool isBuy, uint _amount, address payable from) public payable returns(uint)  {
        require( _amount > 0 );
        if(isBuy) {
            uint exchangeAmount = (_amount * fixedUnit) / buyRate;
            require(exchangeAmount <= token.balanceOf(contractAddr));
            token.transfer(from, exchangeAmount);
            return exchangeAmount;
            
        } 
        else {
            token.approve(contractAddr, _amount);
            require( token.allowance( msg.sender, contractAddr ) == _amount );
            token.transferFrom(msg.sender, contractAddr, _amount);
            
            uint exchangeAmount = (_amount * sellRate) / fixedUnit;
            require(exchangeAmount <= contractAddr.balance);
            
            from.transfer(exchangeAmount);
            return exchangeAmount;

        }
    }
    
}