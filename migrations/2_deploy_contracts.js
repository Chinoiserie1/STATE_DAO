var DAO = artifacts.require("./DAO.sol");
// var DT = artifacts.require("./DT.sol");
// var DSS = artifacts.require("./SocialSecurity.sol");
// var Compagnys = artifacts.require("./Compagnys.sol");

module.exports = async function(deployer) {
  await deployer.deploy(DAO);
};
