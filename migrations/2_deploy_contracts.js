var DAO = artifacts.require("./DAO.sol");
// var DT = artifacts.require("./DT.sol");
var DSS = artifacts.require("./SocialSecurity.sol");
var Compagnys = artifacts.require("./Compagnys.sol");

module.exports = async function(deployer) {
  // await deployer.deploy(DAO).then( () => {
  //   return deployer.deploy(DSS, DAO.address);
  // });
  await deployer.deploy(DAO);
  await deployer.deploy(Compagnys);
  // const dao = await DAO.deployed();
  // const dss = await DSS.deployed();
  // let result;
  // await dao.setDAOSocialSecurity(dss.address);
  // console.log(result);
};
