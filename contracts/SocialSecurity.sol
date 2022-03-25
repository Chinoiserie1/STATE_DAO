// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// this contract is for social security i will implement NFT but non-tradable for each citizen
// this contract is on-chain and just the citizen can see the info or approve user;
// Im thinking about using SVG for citizen can see their social security as an nft
contract SocialSecurity {
  string public name = "DAOSocialSecurity";
  string public symbol = "DSS";
  address public authorizedContract;
  uint256 public avantages = 15; // 15%

  mapping(uint256 => address) public ownerOf;
  mapping(address => uint256) public balanceOf;
  // this allowance it's for share ur social security
  mapping(address => address) public allowance;
  mapping(address => datas) private metadata;

  struct datas {
    uint256 id;
    uint256 avantage;
    string fName;
    string lName;
  }

  event Mint(address _citizen, uint256 _id);
  event Approve(address _citizen, address _approved);

  constructor(address _contract) {
    authorizedContract = _contract;
  }
  modifier onlyAutoContract() {
    require(msg.sender == authorizedContract, "U are not authorized");
    _;
  }
  function mint(address _citizen, string memory _fName, string memory _lName, uint256 _id) public onlyAutoContract() {
    datas memory _data;
    require(bytes(_fName).length > 0 && bytes(_lName).length >0, "Non existant First name or Last name");
    require(balanceOf[_citizen] != 1, "U already have Social Security");
    ownerOf[_id] = _citizen;
    balanceOf[_citizen] = 1;
    _data.id = _id;
    _data.fName = _fName;
    _data.lName = _lName;
    metadata[_citizen] = _data;
    emit Mint(_citizen, _id);
  }
  function approve(address _approved) public {
    require(balanceOf[msg.sender] == 1, "Citizen doesnt exist");
    allowance[msg.sender] = _approved;
    emit Approve(msg.sender, _approved);
  }
  function getMetadata(address _citizen) public view returns(datas memory _data) {
    require(msg.sender == _citizen || msg.sender == allowance[_citizen] 
      || msg.sender == authorizedContract, "U are not authorized");
    _data = metadata[_citizen];
    _data.avantage = avantages;
    return _data;
  }
  function setAvantages(uint256 _newAvantage) public onlyAutoContract() {
    avantages = _newAvantage;
  }
}