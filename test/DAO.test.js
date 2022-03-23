const DAO = artifacts.require('./DAO');

require('chai')
  .use(require('chai-as-promised'))
  .should()

const tokens = (n) => {
  return web3.utils.toBN(
    web3.utils.toWei(n.toString(), 'ether')
  );
}

contract('DAO', ([deployer]) => {
  
})