// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./DT.sol"; // DT is the DAO currency ( erc20 )

contract Compagny {
  using SafeMath for uint;
  string public compagny;
  uint256 public id = 0;
  uint256 public taxe = 10;
  address public owner;
  DT public DAOToken;

  mapping(address => uint256) ownerOf;
  mapping(uint256 => data) metadata;

  event CreateNewJob(address _newEmployee, string _position, uint256 _salary, uint256 _creationTime, uint256 _id);
  event Fired(address _citizen, uint256 _finishTime, uint256 _id);
  event NewSalary(address _citizen, uint256 _newSalary);
  event NewSalaryPeriod(address _citizen, uint256 _newSalaryPeriod);
  event Payment(address _citizen, uint256 _payment);

  struct data {
    address citizen;
    string position;
    // what is the base for salary 7d or 30d every year?
    uint256 salary; 
    uint256 salaryPeriod; // salary period its for know in what base we are if its salary per month so enter 7 or per year enter 364
    uint256 creationTime;
    // active it's important because we can not just delete the metada when fired because we can't have any tracability
    uint256 finishTime;
    bool active;
    // for payment
    uint256 lastPayment;
  }

  constructor(address _token, address _owner, string memory _name) {
    data memory _data;
    DAOToken = DT(_token);
    owner = _owner;
    compagny = _name;
    ownerOf[_owner] = id;
    _data.citizen = owner;
    _data.position = "CEO";
    _data.salary = 0;
    _data.salaryPeriod = 0;
    _data.creationTime = block.timestamp;
    _data.lastPayment = block.timestamp;
    _data.active = true;
    metadata[id] = _data;
    emit CreateNewJob(owner, _data.position, 0, _data.creationTime, id);
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
  function setSalary(address _citizen, uint256 _newSalary) public onlyOwner() {
    uint256 _id = ownerOf[_citizen];
    metadata[_id].salary = _newSalary;
    emit NewSalary(_citizen, _newSalary);
  }
  function setSalaryPeriod(address _citizen, uint256 _newSalaryPeriod) public onlyOwner() {
    uint256 _id = ownerOf[_citizen];
    metadata[_id].salaryPeriod = _newSalaryPeriod;
    emit NewSalaryPeriod(_citizen, _newSalaryPeriod);
  }

  function createNewJob(address _newEmployee, string memory _position, uint256 _salary, uint256 _salaryPeriod) public onlyOwner() {
    data memory _data;
    ownerOf[_newEmployee] = id;
    _data.citizen = _newEmployee;
    _data.creationTime = block.timestamp;
    _data.lastPayment = block.timestamp;
    _data.position = _position;
    _data.salary = _salary;
    _data.salaryPeriod = _salaryPeriod;
    _data.active = true;
    metadata[id] = _data;
    emit CreateNewJob(_newEmployee, _position, _salary, _data.creationTime, id);
    id = id.add(1);
  }
  function fired(address _citizen) public onlyOwner() {
    uint256 _id = ownerOf[_citizen];
    data memory _data = metadata[_id];
    _data.active = false;
    _data.finishTime = block.timestamp;
    metadata[_id] = _data;
    emit Fired(_citizen, _data.finishTime, _id);
  }
  function calculPeriod(uint256 _lastPayment) internal view returns(uint256 result) {
    uint256 time = block.timestamp;
    uint256 counter = 0;
    while (_lastPayment <= time) {
      if (_lastPayment.add(1 days) <= time) {
        counter = counter.add(1);
        _lastPayment = _lastPayment.add(1 days);
      }
    }
    return counter;
  }
  function calculSalary(uint256 _id) internal view returns (uint256 result) {
    data memory _data = metadata[_id];
    uint256 salary = _data.salary;
    uint256 lastPayment = metadata[_id].lastPayment;
    uint256 period = calculPeriod(lastPayment);
    uint256 res = 0;
    salary = salary.div(_data.salaryPeriod);
    res = salary.mul(period);
    return res;
  }
  function getPaid(address _citizen) public onlyOwner() {
    uint256 _id = ownerOf[_citizen];
    metadata[_id].lastPayment = block.timestamp;
    uint256 res = calculSalary(_id);
    require(DAOToken.transfer(_citizen, res), "failed to transfer");
    emit Payment(_citizen, res);
  }

}