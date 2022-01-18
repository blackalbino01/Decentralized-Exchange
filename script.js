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

		const reserve = await Reserve.new('0xdac17f958d2ee523a2206206994597c13d831ec7',{from: owner});
		const exchange = await Exchange.new();

		let move = await ludo.moveMarker( [57,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1],1,13, 6, { from: manager});

		let random = await ludo.random({ from: manager});

		let arr = [];
		for (var i = 0; i < move[0].length; i++) {
			arr.push(move[0][i].toNumber())
		}
		console.log(arr, move[1], move[2]);
		console.log(random.toNumber())
	}

	catch(error){
		console.log(error);
	}

	callback();
}