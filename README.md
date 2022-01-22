# A Simple Decentralized Exchange
I created this repository for testing purpose. 

The way I defined the exchange rates in Reserve contract might be unusual:
Exchange Rate consists of the Token Rate and Ether Rate. Let's say we want to trade from Eth <-> token  or token A <-> token B
+ Token rate: how many token amount to trade an Eth or how many token amount B to trade a token A. 
+ Ether rate: received how many Ether when trading token or received how many token A when trading token B.

#### For example, if you input `rate` to `setExchangeRates(250)`. As a result:
+ Buy procedure: 2 Eth =  500 token or 400 token A = 100,000 token B.
+ Sell procedure: 600 token  = 2.4 Eth or 600,500 token B = 2402 token A.

## Supported Features:
+ Trade between Eth and tokens
+ Liquidity Pool/Reserve.
+ Trade between tokens.
+ Ask permission everytime when trading tokens.

## TODO
+ Deploying to public network(rinkeby)
+ Contract interaction on the UI
+ UI finishing
