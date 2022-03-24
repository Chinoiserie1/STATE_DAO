const DAO = artifacts.require('./DAO');
const Token = artifacts.require('./DT');

require('chai')
  .use(require('chai-as-promised'))
  .should()

const tokens = (n) => {
  return web3.utils.toBN(
    web3.utils.toWei(n.toString(), 'ether')
  );
}

contract('DAO', ([deployer]) => {
  let dao;
  let token;
  beforeEach(async () => {
    token = await Token.deployed();
    dao = await DAO.deployed();
  })
  describe('start', () => {
    // console.log(token.address);
    // console.log(dao);
    it('check deployed correctly', async () => {
      // console.log(dao.address);
      // console.log(token.address);
      let result = await dao.DAOToken.call();
      // console.log(result);
      result.should.equal(token.address);
    })
  })
})