// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// this contract its for create a compagny in the DAO and allocate jobs
contract Compagny {
  address public authorizedContract;
  uint256 public compagnyId = 0;

  mapping(uint256 => address) compagnyOwner;
  // one person can have multiple compagny
  mapping(address => uint256) balanceOf;

  constructor(address _contract) {
    authorizedContract = _contract;
  }

  modifier onlyAutoContract() {
    require(msg.sender == authorizedContract, "U are not authorized");
    _;
  }

  function createCompagny(string memory _name) public {

  }
}