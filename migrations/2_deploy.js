const Reserve = artifacts.require("Reserve");
const Exchange = artifacts.require("Exchange");


module.exports = async function (deployer) {
  // Deploy Reserve
  await deployer.deploy(Reserve, '0xdac17f958d2ee523a2206206994597c13d831ec7');
  await Reserve.deployed()

  // Deploy Exchange
  await deployer.deploy(Exchange);
  await Exchange.deployed();

};
