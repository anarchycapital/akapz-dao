//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "@openzeppelin/contracts/utils/Address.sol";

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "./Fees.sol";


contract Akapz is Initializable, AccessControlEnumerable, ERC20Votes {

using Address for address;

 

address private _owner;
uint private _initialized = 0;
uint256 public s_maxSupply; // 100 millions akapz tokens
    uint256 public _initialSupply;

event Deposited(address indexed _from, uint _amount);
    event HolderRegistered(address indexed _holder, uint atBlock);

bytes32 private constant UPGRADER_ROLE = keccak256(abi.encode("UPGRADER_ROLE"));
bytes32 private constant OWNER_ROLE = keccak256(abi.encode("OWNER_ROLE"));
bytes32 private constant FOUNDER_ROLE = keccak256(abi.encode("FOUNDER_ROLE"));

    mapping(address => bool) public _holders;

    constructor(string memory name, string memory symbol, address owner_) ERC20(name, symbol) ERC20Permit(name)  {
        initialize(name, symbol, owner_);
    }

function initialize(string memory name, string memory symbol, address owner_) public  {



        __Akapz_init(owner_);
        

}


function __Akapz_init(address owner_) private {
    _setOwner(owner_);
    _setupRole(UPGRADER_ROLE, owner_);
    s_maxSupply = 100000000 * 10 ** 18;
    _initialSupply = s_maxSupply / 5;
    _mint(owner_, _initialSupply);

}

    function _setOwner(address owner_) internal {
    require(owner_ != address(0), "owner cannot be address zero");
    _owner = owner_;
}

modifier onlyUpgrader(address sender) {
    require(hasRole(UPGRADER_ROLE, sender), "not authorized for upgrades");
    _;
}



function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20Votes) {
    if(amount >= 1) {
        _holders[to] = true;
    }
    emit HolderRegistered(to, block.number);
    super._afterTokenTransfer(from, to, amount);
}

function mint(address to, uint256 amount) public onlyUpgrader(msg.sender) {
    _mint(to, amount);
}

function _mint(address to, uint256 amount) internal override(ERC20Votes) {
    super._mint(to, amount);
  }
function _burn(address account, uint256 amount) internal override(ERC20Votes) {
    super._burn(account, amount);
  }

receive() external payable {
    emit Deposited(_msgSender(), msg.value);
}

    modifier onlyHolder(address sender) {
        require(_holders[sender] == true, "you need at least 1 Akap to gather fees");
        _;
    }


}