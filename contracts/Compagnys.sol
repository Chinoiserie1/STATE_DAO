// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./DT.sol"; // DT is the DAO currency ( erc20 )
import "./Compagny.sol";

// This contract its for create a compagny in the DAO and allocate jobs
// This contract need to create nft of compagny's goods
// Compagnys contract its for the list of all compagny with they metadata, each compagny have an 
// another contract for the compagny nd jobs

contract Compagnys {
  using SafeMath for uint;
  address public authorizedContract;
  uint256 public compagnyId = 0;
  uint256 public taxes = 5;
  DT public DAOToken;

  mapping(uint256 => address) compagnyOwner;
  // one person can have multiple compagny
  mapping(address => uint256) balanceOf;
  mapping(uint256 => data) metadata;
  mapping(address => uint256[]) compagnyOf;

  event NewCompagny(string _name, string _category, Compagny _compagny, uint256 _compagnyId);

  struct data {
    string name;
    string category;
    uint256 timeCreation;
    Compagny compagny;
  }

  constructor(address _token) {
    authorizedContract = msg.sender;
    DAOToken = DT(_token);
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
    _data.compagny = new Compagny(address(DAOToken), msg.sender, _name); // create a new contract Compagny
    metadata[compagnyId] = _data;
    emit NewCompagny(_name, _category, _data.compagny, compagnyId);
    compagnyId.add(1);
  }
  function getCompagnyInfo(uint256 _compagnyId) public view returns(data memory _info) {
    return metadata[_compagnyId];
  }
  function getMyCompagnyId() public view returns(uint256[] memory _ids) {
    return compagnyOf[msg.sender];
  }
}

// reflexion: comment savoir si l'employer travail bien est ce que c lui qui demande largent ou bien le CEO qui envoie largent?