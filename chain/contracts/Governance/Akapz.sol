//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.9;


import "../../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "../../node_modules/@openzeppelin/contracts/token/ERC20/extensions/ERC20Votes.sol";
import "../../node_modules/@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "../../node_modules/@openzeppelin/contracts/proxy/utils/UUPSUpgradeable.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Address.sol";
import "../../node_modules/@openzeppelin/contracts/utils/Context.sol";
import "../../node_modules/@openzeppelin/contracts/access/AccessControlEnumerable.sol";


contract Akapz is Context, AccessControlEnumerable, ERC20Votes {

using Address for address;

address private _owner;
uint private _initialized = 0;
uint256 public s_maxSupply = 100000000 * 10 ** 18; // 100 millions akapz tokens

event Deposited(address indexed _from, uint _amount);

bytes32 private constant UPGRADER_ROLE = keccak256(abi.encode("UPGRADER_ROLE"));
bytes32 private constant OWNER_ROLE = keccak256(abi.encode("OWNER_ROLE"));
bytes32 private constant FOUNDER_ROLE = keccak256(abi.encode("FOUNDER_ROLE"));

constructor(string memory name, string memory symbol, address owner_) ERC20(name, symbol) ERC20Permit("Akapz") {

        _setOwner(owner_);
        _setupRole(UPGRADER_ROLE, owner_);
        _mint(_msgSender(), s_maxSupply);

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
    super._afterTokenTransfer(from, to, amount);
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


}