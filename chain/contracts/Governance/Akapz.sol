//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;


import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/extensions/ERC20VotesUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";
//import "@openzeppelin/contracts-upgradeable/utils/ContextUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/AccessControlEnumerableUpgradeable.sol";
import "./Fees.sol";

import '@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol';

contract Akapz is Initializable, UUPSUpgradeable, AccessControlEnumerableUpgradeable, ERC20VotesUpgradeable, Fees {

using AddressUpgradeable for address;

    IUniswapV2Router02 public uniswapRouter;
    address public constant UNISWAP_ROUTER_ADDRESS = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

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

    constructor(string memory name, string memory symbol, address owner_) {
        initialize(name, symbol, owner_);
    }

function initialize(string memory name, string memory symbol, address owner_) public virtual initializer {

    uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
        __AccessControlEnumerable_init();
        __ERC20_init(name, symbol);
        __ERC20Permit_init(name);
        __Fees_Init();

        __Akapz_init(owner_);
        __UUPSUpgradeable_init();

}

    function swapEthForExactTokens(address _tokenAddr) public override(IUniswapV2Router02) {
        address[] memory path = new address[](2);
        path[0] = address(_tokenAddr);
        path[1] = uniswapRouter.WETH();
    }

    function convertEthToDai(uint daiAmount) public payable {
        uint deadline = block.timestamp + 15; // using 'now' for convenience, for mainnet pass deadline from frontend!
        uniswapRouter.swapETHForExactTokens{ value: msg.value }(daiAmount, getPathForETHtoDAI(), address(this), deadline);

        // refund leftover ETH to user
        (bool success,) = msg.sender.call{ value: address(this).balance }("");
        require(success, "refund failed");
    }

    function getEstimatedETHforDAI(uint daiAmount) public view returns (uint[] memory) {
        return uniswapRouter.getAmountsIn(daiAmount, getPathForETHtoDAI());
    }

    function getPathForETHtoDAI() private view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = address(this);

        return path;
    }


    function _authorizeUpgrade(address newImplementation) internal virtual onlyUpgrader(msg.sender) override {}

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



function _afterTokenTransfer(address from, address to, uint256 amount) internal override(ERC20VotesUpgradeable) {
    if(amount >= 1) {
        _holders[to] = true;
    }
    emit HolderRegistered(to, block.number);
    super._afterTokenTransfer(from, to, amount);
}



function _mint(address to, uint256 amount) internal override(ERC20VotesUpgradeable) {
    super._mint(to, amount);
  }
function _burn(address account, uint256 amount) internal override(ERC20VotesUpgradeable) {
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