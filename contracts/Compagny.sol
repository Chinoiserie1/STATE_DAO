// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

// this contract its for create a compagny in the DAO and allocate jobs
// this contract need to create nft of good the compagny sell
contract Compagny {
  using SafeMath for uint;
  address public authorizedContract;
  uint256 public compagnyId = 0;

  mapping(uint256 => address) compagnyOwner;
  // one person can have multiple compagny
  mapping(address => uint256) balanceOf;
  mapping(uint256 => data) metadata;
  // thinking about how we can implement jobs
  mapping(uint256 => mapping(address => uint256)) jobs;

  struct data {
    string name;
    uint256 timeCreation;
  }
  struct employeeData {
    string p;
    uint256 timeStart;
  }

  constructor(address _contract) {
    authorizedContract = _contract;
  }

  modifier onlyAutoContract() {
    require(msg.sender == authorizedContract, "U are not authorized");
    _;
  }

  function createCompagny(string memory _name) public {
    data memory _data;
    compagnyOwner[compagnyId] = msg.sender;
    balanceOf[msg.sender] = balanceOf[msg.sender].add(1);
    _data.name = _name;
    _data.timeCreation = block.timestamp;
    metadata[compagnyId] = _data;
    compagnyId.add(1);
  }
  function createJob(address _employee) public {

  }
}