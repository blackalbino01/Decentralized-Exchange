const TestToken = artifacts.require("TestToken");
const Reserve = artifacts.require("Reserve");
const Exchange = artifacts.require("Exchange");


module.exports = async function (deployer) {

  // Deploy TestToken
  await deployer.deploy(TestToken);
  const testToken = await TestToken.deployed();

  // Deploy Reserve
  await deployer.deploy(Reserve, testToken.address);
  const reserve = await Reserve.deployed()

  // Deploy Exchange
  await deployer.deploy(Exchange);
  await Exchange.deployed();

  function tokens(n) {
    return web3.utils.toWei(n, 'ether');
  }

  // Transfer all tokens to reserve (1 million)
  await testToken.transfer(reserve.address, tokens('1000000'));

};
