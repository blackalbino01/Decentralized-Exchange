// SPDX-License-Identifier: MIT
pragma solidity 0.8.10;
import "./TestToken.sol";

contract Reserve {
    
    address public contractAddr = address(this);
    address nativeToken = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;

    TestToken public token;

    uint fixedUnit = 10**18;
    uint rate;

    constructor(address _token){
        token = TestToken(_token);

    }

    function addLiquidity(uint _amount) public payable {
        token.transferFrom(msg.sender, contractAddr, _amount);
    }

    function getToken() public view returns(address){
        return address(token);
    }

    function getTokenBalance() public view returns(uint) {
        
        return token.balanceOf(contractAddr);
        
    }

    function getBalance() public view returns(uint){
        return contractAddr.balance;
    }

    function setRates(uint _rate) public {
        
        rate = _rate ;
    }
    
    function getTokenRate(uint _ethSold) public view returns (uint) {
        require(_ethSold > 0, "ethSold is too small");
        return (_ethSold * rate) / fixedUnit;
    }

    function getEthRate(uint _tokenSold) public view returns (uint) {
        require(_tokenSold > 0, "tokenSold is too small");
        return (_tokenSold * fixedUnit) / rate;
    }

    function exchange(bool isBuy, uint _amount, address _from) payable public returns(uint) {
        require(_amount > 0);
        
        if(isBuy) {
            require(msg.value == _amount);
            uint tokenReserve = getTokenBalance();
            uint tokensBought = getTokenRate(msg.value);
            require(tokensBought <= tokenReserve, "insufficient output amount");
            token.transfer(_from, tokensBought);

            return tokensBought;
             
        } else{
            
            uint EthReserve = getBalance();
            uint ethBought = getEthRate( _amount);

            require(ethBought <= EthReserve, "insufficient output amount");
            token.approve(contractAddr, _amount);
            token.transferFrom(
                _from,
                contractAddr,
                _amount
            );
            payable(_from).transfer(ethBought);

            return ethBought;
        } 
    }

    function tokenSwap(uint _amount, address _to) public {
        uint tokenSwapped = getTokenRate(_amount);
        token.transfer(_to, tokenSwapped);
    } 

}
    