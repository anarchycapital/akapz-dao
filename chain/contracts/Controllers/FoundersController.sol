//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "../Libraries/Founders.sol";
import "./ACLController.sol";

contract FoundersController is Ownable, ACLController {

    event DirectorAdded(address indexed _founderAddress, uint256 _dedicatedAmount, uint timestamp);
    event DirectorRemoved(address indexed _directorRemoved, string reason, uint timestamp);
    event PercentFundsPerDirectorChanged(uint256 _oldValue, uint256 _newValue);

    Founders.founderData private _data;
    mapping(address => Founders.founderData) private _foundersDirectory;

    bytes32 public constant NOTSET_ROLE = keccak256(abi.encode("NOTSET"));
    uint256 private DedicatedPercentForDirector = 1; // 1% per director will be set

    function AddDirector(string memory name, bytes32  roles, address wallet) public onlyOwner {

    }

    function PercentFundsPerDirector() public view virtual returns (uint256) {
        return DedicatedPercentForDirector;
    }

    function ChangePercentFundsPerDirector(uint256 newValue) public onlyOwner {
        uint256 oldValue = DedicatedPercentForDirector;
            DedicatedPercentForDirector = newValue;
        emit PercentFundsPerDirectorChanged(oldValue, newValue);
    }


    function _addNewDirector(address  _founderAddress, uint256 _dedicatedAmount, Founders.founderData memory __data) private onlyOwner {
        _foundersDirectory[_founderAddress] = __data;

    }

    function _initNewDirector(string memory name, bytes32  roles, address wallet) public onlyOwner {
        _data = Founders._createFounder(name, roles, wallet);
    }

    function _resetData() private onlyOwner {
        _data.name = "";
        _data.roles = NOTSET_ROLE;
        _data.wallet = address(0x0000000000000000000000000000000000000000);
    }

}