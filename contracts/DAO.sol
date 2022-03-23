// SPDX-License-Identifier: MIT
pragma solidity >=0.4.21 <0.9.0;

contract DAO {
  address public owner;
  address public DT;

  mapping(address => User) citizen;

  struct User {
    uint256 id;
  }

  constructor() {
    owner = msg.sender;
  }

  modifier onlyOwner() {
    require(owner == msg.sender, "U are not the owner");
    _;
  }


}