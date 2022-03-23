var DAO = artifacts.require("./DAO.sol");
var DT = artifacts.require("./DT.sol");

module.exports = function(deployer) {
  deployer.deploy(DAO);
  deployer.deploy(DT);
};
