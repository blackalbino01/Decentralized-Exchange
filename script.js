const TestToken = artifacts.require("TestToken");
const Reserve = artifacts.require("Reserve");
const Exchange = artifacts.require("Exchange");



function tokens(n) {
  return web3.utils.toWei(n, 'ether');
}

module.exports = async function(callback) {

	try{
		const accounts = await web3.eth.getAccounts();

		const owner = accounts[0]

		const trader = accounts[1]

		const testToken = await TestToken.new();
		const reserve = await Reserve.new(testToken.address,{from: owner});
		const exchange = await Exchange.new();

		await testToken.transfer(reserve.address, tokens('1000000'));

		const balance = await reserve.getTokenBalance()
		console.log(balance.toString())
		let rate = await reserve.getExchangeRate(true,3000,{ from: owner});

		console.log(rate.toNumber())
	}

	catch(error){
		console.log(error);
	}

	callback();
}