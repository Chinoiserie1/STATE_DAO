// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "../node_modules/@openzeppelin/contracts/utils/math/SafeMath.sol";

contract DT {
  using SafeMath for uint;

  string public name = "DAO Token";
  string public symbol = "DT";
  uint256 public decimals = 18;
  uint256 public totalSupply;
  address public authorizedContract;
  address public owner;

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);

  constructor() {
    owner = msg.sender;
    totalSupply = 0;
  }

  modifier onlyOwner() {
    require(msg.sender == owner, "U are not the owner");
    _;
  }

  //primary function ERC20
  function transfer(address _to, uint256 _value) public returns (bool success) {
    _transfer(msg.sender, _to, _value);
    return true;
  }
  function _transfer(address _from, address _to, uint256 _value) internal {
    require(_to != address(0));
    require(balanceOf[_from] >= _value, "not enougth token to send");
    balanceOf[_from] = balanceOf[_from].sub(_value);
    balanceOf[_to] = balanceOf[_to].add(_value);
    emit Transfer(_from, _to, _value);
  }
  function approve(address _spender, uint256 _value) public returns (bool success) {
    require(_spender != address(0), "can not be address 0");
    allowance[msg.sender][_spender] = _value;
    emit Approval(msg.sender, _spender, _value);
    return true;
  }
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
    require(allowance[_from][msg.sender] >= _value, "not allowed or value too higth");
    _transfer(_from, _to, _value);
    allowance[_from][msg.sender] = allowance[_from][msg.sender].sub(_value);
    emit Approval(_from, msg.sender, allowance[_from][msg.sender]);
    return true;
  }
  function mint(address _citizen, uint256 _amount) public returns (bool success) {
    // require(msg.sender == authorizedContract, "not authorized to mint");
    // for test DT msg.sender == owner will be remove in final code
    require(msg.sender == authorizedContract || msg.sender == owner, "not authorized to mint");
    require(_citizen != address(0), "invalid address");
    require(_amount > 0, "amount need to be positive");
    totalSupply = totalSupply.add(_amount);
    balanceOf[_citizen] = balanceOf[_citizen].add(_amount);
    emit Transfer(address(0), _citizen, _amount);
    return true;
  }
  //onlyOwner
  function setAutorizedContract(address _contract) public onlyOwner() {
    authorizedContract = _contract;
  }
  function setOwner(address _newOwner) external onlyOwner() {
    owner = _newOwner;
  }
}