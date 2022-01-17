pragma solidity 0.8.10;
import './Reserve.sol';

contract Exchange {
    
    address nativeToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
    address contractAddr = address(this);
    mapping (address => Reserve) reserves;
    mapping (address => bool) reserved;
    uint fixedUnit = 10**18;

    constructor(){
        reserved[nativeToken] = true;
    }


    function addReserve(address _reserve, address token) public {
        
        require(!reserved[token]);
        Reserve reserve = Reserve(_reserve);
        reserves[token] = reserve;
        reserved[token] = true;
        
    }

    function getExchangeRate(address srcToken, address destToken, uint _amount) public view returns (uint) {
        require(_amount > 0);
        require(reserved[srcToken] && reserved[destToken]);
        if(srcToken == nativeToken) {
            return reserves[destToken].getExchangeRate(true, _amount);
        } else if (destToken == nativeToken) {
            return reserves[srcToken].getExchangeRate(false, _amount);
        } else {
            uint sellRate4srcToken = reserves[srcToken].getExchangeRate(false, _amount);
            uint srcToken2ETH = _amount * sellRate4srcToken / fixedUnit;
            uint buyRate4destToken = reserves[destToken].getExchangeRate(true, srcToken2ETH);
            
            if(buyRate4destToken > 0 && sellRate4srcToken > 0)
                return sellRate4srcToken * fixedUnit/ buyRate4destToken;
            return 0;
        }
    }

    function exchange(address srcToken , address destToken, uint _amount) payable public {
        require(_amount > 0);
        require(reserved[srcToken] && reserved[destToken]);
        
        if(srcToken == nativeToken) {
            
            require(msg.value == _amount);
            reserves[destToken].exchange(true, _amount, msg.sender);
             
        } else if (destToken == nativeToken) {
            
            IERC20 token = IERC20(srcToken);
            require( token.allowance( msg.sender, contractAddr ) == _amount );
            token.transferFrom( msg.sender, contractAddr, _amount );
            
            Reserve srcReserve = reserves[srcToken];
            token.approve( srcReserve.contractAddr(), _amount );
            
            srcReserve.exchange( false, _amount, msg.sender );
            
        } else {
            // phase 1, sell token
            token = IERC20(srcToken);
            require( token.allowance( msg.sender, contractAddr ) == _amount );
            token.transferFrom( msg.sender, contractAddr, _amount );
            
            srcReserve = reserves[srcToken];
            token.approve( srcReserve.thisAddr(), _amount );
            
            uint ETHreceived = srcReserve.exchange( false, _amount, contractAddr );
            
            // phase 2, buy destToken
            
            reserves[destToken].exchange(true, ETHrecieved, msg.sender);

        }
    // }
}