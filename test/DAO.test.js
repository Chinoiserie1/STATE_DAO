const DAO = artifacts.require('./DAO');
const Token = artifacts.require('./DT');
const DSS = artifacts.require('./SocialSecurity');

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
  let dss;
  beforeEach(async () => {
    token = await Token.deployed();
    dao = await DAO.deployed();
    dss = await DSS.deployed();
  })
  describe('start', () => {
    it('check if deployed correctly with token address', async () => {
      let result = await dao.DAOToken.call();
      result.should.equal(token.address);
    })
    it('check if DAO SocialSecurity deploy correctly', async () => {
      let result = await dss.authorizedContract.call();
      result.should.equal(dao.address);
    })
  })
  describe('DAO', () => {
    describe('add new citizen', async () => {
      let result;
      const firstName = "Jeremie";
      const lastName = "Lucotte";
      it('new citizen from user1', async () => {
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
      it('failed when same user call newCitizen', async () => {
        await dao.newCitizen(firstName, lastName, { from: user1 })
        .should.be.rejectedWith('VM Exception while processing transaction: revert U already have Social Security');
      })
    })
    describe('DAO SocialSecurity', async () => {
      it('mint social security', async () => {
        let res = await dss.balanceOf(user1);
        res.toString().should.equal('1');
      })
      it('get the metadata', async () => {
        let res = await dss.getMetadata(user1, { from: user1 });
        res.id.toString().should.equal('0');
        res.avantage.toString().should.equal('15');
        res.fName.should.equal("Jeremie");
        res.lName.should.equal("Lucotte");
      })
      it('failed when user directly mint social security',  async () => {
        await dss.mint(user1, "jeremie", "lucotte", 10, { from: user1 })
          .should.be.rejectedWith('VM Exception while processing transaction: revert U are not authorized');
      })
      it('failed when not approved user want to get metadata', async () => {
        await dss.getMetadata(user1, { from: user2 })
          .should.be.rejectedWith('VM Exception while processing transaction: revert U are not authorized');
      })
      it('approve user to get metadata', async () => {
        await dss.approve(user2, { from: user1 });
        let res = await dss.allowance(user1);
        res.should.equal(user2);
      })
      it('approved user to see metadata', async () => {
        let res = await dss.getMetadata(user1, { from: user2 });
        res.id.toString().should.equal('0');
        res.avantage.toString().should.equal('15');
        res.fName.should.equal("Jeremie");
        res.lName.should.equal("Lucotte");
      })
    })
  })
})