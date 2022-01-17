pragma solidity 0.8.10;
import "@openzeppelin/contracts/interfaces/IERC20.sol";

contract Reserve {
    
    address public contractAddr = address(this);

    IERC20 token;

    uint fixedUnit = 10**18;
    uint buyRate;
    uint sellRate;

    constructor(address _token){
        token = IERC20(_token);

    }   
     
    
    function setExchangeRates(uint _buyRate, uint _sellRate) public {
        
        buyRate = _buyRate ;
        sellRate = _sellRate;
        
    }
    
    function getExchangeRate(bool isBuy, uint _amount) public view returns (uint) {
        
        if(isBuy) {
            
            if(_amount * fixedUnit / buyRate  <= token.balanceOf(contractAddr) ) {
                
                return buyRate;
            
            }
            else return 0;
        } else {
            
            if(_amount * sellRate / fixedUnit <= contractAddr.balance ) {
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
        
        if(isBuy) {
            
            require(msg.value == _amount);
            
            uint exchangeAmount = _amount * fixedUnit / buyRate;
            require(exchangeAmount <= token.balanceOf(contractAddr));
            token.transfer(from, exchangeAmount);
            return exchangeAmount;
            
        } 
        else {
            
            require( token.allowance( msg.sender, contractAddr ) == _amount );
            token.transferFrom(msg.sender, contractAddr, _amount);
            
            exchangeAmount = _amount * sellRate / fixedUnit;
            require(exchangeAmount <= thisAddr.balance);
            
            from.transfer(exchangeAmount);
            return exchangeAmount;

        }
    }
    
}