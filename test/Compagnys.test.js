const Compagnys = artifacts.require('./Compagnys.sol');
const DT = artifacts.require('./DT.sol');

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
  let daoToken;
  describe('start', () => {
    it('check autorized address', async () => {
      compagny = await Compagnys.new();
      let result = await compagny.authorizedContract.call();
      result.should.equal(deployer);
    })
    it('deploy DAO Token', async () => {
      daoToken = await DT.new();
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
    })
    it('check event', async() => {
      let log = result.logs[0];
        log.event.should.equal('newCompagny');
        const res = log.args;
        res._name.should.equal(name);
        res._category.should.equal(category);
        res._compagny.should.equal(compagnyAddr);
        res._compagnyId.toString().should.equal('0');
    })
  })
})