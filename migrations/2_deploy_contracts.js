var DAO = artifacts.require("./DAO.sol");
var DT = artifacts.require("./DT.sol");
var DSS = artifacts.require("./SocialSecurity.sol");

module.exports = async function(deployer) {
  await deployer.deploy(DT).then( () => {
    return deployer.deploy(DAO, DT.address).then( () => {
      return deployer.deploy(DSS, DAO.address);
    });
  });
  const dt = await DT.deployed();
  const dao = await DAO.deployed();
  const dss = await DSS.deployed();
  let result = await dao.setDAOSocialSecurity(dss.address);
  console.log(result);
};
