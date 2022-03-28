// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

// This contract its for create a compagny in the DAO and allocate jobs
// This contract need to create nft of compagny's goods
// Compagnys contract its for the list of all compagny with they metadata, each compagny have an 
// another contract for the compagny nd jobs

contract Compagnys {
  using SafeMath for uint;
  address public authorizedContract;
  uint256 public compagnyId = 0;

  mapping(uint256 => address) compagnyOwner;
  // one person can have multiple compagny
  mapping(address => uint256) balanceOf;
  mapping(uint256 => data) metadata;
  mapping(address => uint256[]) compagnyOf;

  event newCompagny(string _name, string _category, Compagny _compagny, uint256 _compagnyId);

  struct data {
    string name;
    string category;
    uint256 timeCreation;
    Compagny compagny;
  }

  constructor() {
    authorizedContract = msg.sender;
  }

  modifier onlyAutoContract() {
    require(msg.sender == authorizedContract, "U are not authorized");
    _;
  }

  function createCompagny(string memory _name, string memory _category) public {
    data memory _data;
    compagnyOwner[compagnyId] = msg.sender;
    balanceOf[msg.sender] = balanceOf[msg.sender].add(1);
    compagnyOf[msg.sender].push(compagnyId);
    _data.name = _name;
    _data.category = _category;
    _data.timeCreation = block.timestamp;
    _data.compagny = new Compagny(msg.sender, _name); // create a new contract Compagny
    metadata[compagnyId] = _data;
    emit newCompagny(_name, _category, _data.compagny, compagnyId);
    compagnyId.add(1);
  }
  function getCompagnyInfo(uint256 _compagnyId) public view returns(data memory _info) {
    return metadata[_compagnyId];
  }
  function getMyCompagnyId() public view returns(uint256[] memory _ids) {
    return compagnyOf[msg.sender];
  }
}

contract Compagny {
  using SafeMath for uint;
  string public compagny;
  uint256 public id = 0;
  address public owner;

  mapping(address => uint256) ownerOf;
  mapping(uint256 => data) metadata;

  struct data {
    address citizen;
    string position;
    uint256 salary;
    uint256 creationTime;
    // active it's important because we can not just delete the metada when fired because we can't have any tracability
    uint256 finishTime;
    bool active;
  }

  constructor(address _owner, string memory _name) {
    data memory _data;
    owner = _owner;
    compagny = _name;
    ownerOf[_owner] = id;
    _data.citizen = owner;
    _data.position = "CEO";
    _data.salary = 0;
    _data.creationTime = block.timestamp;
    _data.active = true;
    metadata[id] = _data;
    id = id.add(1);
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "U are not the owner");
    _;
  }
  function setOwner(address _newOwner) public onlyOwner() {
    data memory _data = metadata[0];
    _data.finishTime = block.timestamp;
    _data.active = false;
    metadata[0] = _data;
    owner = _newOwner;
  }

  function createNewJob(address _newEmployee, string memory _position, uint256 _salary) public onlyOwner() {
    data memory _data;
    ownerOf[_newEmployee] = id;
    _data.citizen = _newEmployee;
    _data.creationTime = block.timestamp;
    _data.position = _position;
    _data.salary = _salary;
    _data.active = true;
    metadata[id] = _data;
    id = id.add(1);
  }
  function fired(address _citizen) public onlyOwner() {
    
  }

}

// reflexion: comment savoir si l'employer travail bien est ce que c lui qui demande largent ou bien le CEO qui envoie largent?