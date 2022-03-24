var DAO = artifacts.require("./DAO.sol");
var DT = artifacts.require("./DT.sol");

module.exports = function(deployer) {
  deployer.deploy(DT).then( () => {
    return deployer.deploy(DAO, DT.address);
  });
};
