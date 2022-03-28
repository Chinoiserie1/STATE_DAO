const SocialSecurity = artifacts.require('./SocialSecurity');

require('chai')
    .use(require('chai-as-promised'))
    .should()

const tokens = (n) => {
    return web3.utils.toBN(
        web3.utils.toWei(n.toString(), 'ether')
    );
}

contract('SocialSecurity', ([deployer, user1, user2]) => {
  const firstName = "Jeremie";
  const lastName = "Lucotte";
  it('deploy Social Security', async () => {
    dss = await SocialSecurity.new();
    await dss.mint(user1, firstName, lastName, 0);
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
    it('failed when call mint a second time',  async () => {
      await dss.mint(user1, "jeremie", "lucotte", 10, { from: user1 })
        .should.be.rejectedWith('VM Exception while processing transaction: revert U already have Social Security');
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
    it('get metadata from approved user', async () => {
      let res = await dss.getMetadata(user1, { from: user2 });
      res.id.toString().should.equal('0');
      res.avantage.toString().should.equal('15');
      res.fName.should.equal("Jeremie");
      res.lName.should.equal("Lucotte");
    })
  })
})