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

contract('DAO', ([deployer, user1, user2]) => {
  let dao;
  let token;
  beforeEach(async () => {
    token = await Token.deployed();
    dao = await DAO.deployed();
  })
  describe('start', () => {
    it('check if deployed correctly with token address', async () => {
      let result = await dao.DAOToken.call();
      result.should.equal(token.address);
    })
  })
  describe('add new citizen', () => {
    let result;
    const firstName = "Alice";
    const lastName = "TSIGO";
    beforeEach(async () => {
      result = await dao.newCitizen(firstName, lastName, { from: user1 });
    })
    it('citizen added successfuly', async () => {
      let res = await dao.getCitizenInfo(user1, { from: user1 });
      res.id.should.equal("0", 'ID check');
      res.firstName.should.equal(firstName, 'first name check');
      res.lastName.should.equal(lastName, 'last name check');
    })
    it('check event', async () => {
      let log = result.logs[0];
      log.event.should.equal('NewCitizen');
      const res = log.args;
      res._id.toString().should.equal("0", 'ID check');
      res._firstName.should.equal(firstName, 'first name check');
      res._lastName.should.equal(lastName, 'last name check');
    })
    it('failed when another person want to get info', async () => {
      await dao.getCitizenInfo(user1, { from: user2 })
        .should.be.rejectedWith('VM Exception while processing transaction: revert U are not able to see this info');
    })
  })
})