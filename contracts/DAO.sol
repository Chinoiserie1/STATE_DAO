// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
// DT is the DAO currency ( erc20 )
import "./DT.sol";
import "./SocialSecurity.sol";
import "./Compagnys.sol";

// actually no security of ur data everyone can check, will improve after :)

contract DAO {
  using SafeMath for uint;

  address public owner;
  DT public DAOToken;
  SocialSecurity public DSS;
  uint256 public totalCitizen = 0;

  mapping(address => User) public citizen;

  event NewCitizen(string _firstName, string _lastName, uint256 _id);

  struct User {
    // user personal info
    uint256 id;
    string firstName;
    string lastName;
    // compagny job info
    address[] compagny;
  }

  constructor() {
    owner = msg.sender;
    DAOToken = new DT();
    DSS = new SocialSecurity();
  }

  modifier onlyOwner() {
    require(owner == msg.sender, "U are not the owner");
    _;
  }

  function newCitizen(string memory _firstName, string memory _lastName) public returns (bool success) {
    User memory _user;
    _user.firstName = _firstName;
    _user.lastName = _lastName;
    _user.id = totalCitizen;
    citizen[msg.sender] = _user;
    emit NewCitizen(_firstName, _lastName, totalCitizen);
    DSS.mint(msg.sender, _firstName, _lastName, totalCitizen);
    totalCitizen.add(1);
    return true;
  }
  function getCitizenInfo(address _citizen) public view returns (User memory _user) {
    require(_citizen == msg.sender, 'U are not able to see this info');
    return citizen[_citizen];
  }
}