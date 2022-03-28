const Compagnys = artifacts.require('./Compagnys.sol');

require('chai')
  .use(require('chai-as-promised'))
  .should()

const tokens = (n) => {
  return web3.utils.toBN(
    web3.utils.toWei(n.toString(), 'ether')
  );
}

contract('Compagnys', ([deployer, user1]) => {
  let compagny;
  beforeEach(async () => {
    compagny = await Compagnys.deployed();
  })
  describe('start', () => {
    it('check autorized address', async () => {
      let result = await compagny.authorizedContract.call();
      result.should.equal(deployer);
    })
  })
  describe('Compagny', () => {
    let name = "NO28";
    let category = "informatique";
    let compagnyAddr;
    let timeCreation;
    let result;
    it('create a compagny', async () => {
      result = await compagny.createCompagny(name, category, { from: user1 });
    })
    it('check data', async() => {
      let res = await compagny.getCompagnyInfo(0);
      compagnyAddr = res.compagny;
      res.name.should.equal(name);
      res.category.should.equal(category);
      // console.log(res);
    })
    it('check event', async() => {
      let log = result.logs[0];
        log.event.should.equal('newCompagny');
        const res = log.args;
        res._name.should.equal(name);
        res._category.should.equal(category);
        res._compagny.should.equal(compagnyAddr);
        console.log(res);
    })
  })
})