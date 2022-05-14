// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";

abstract contract ACLController is Ownable, AccessControlEnumerable {


    bytes32 public constant ROLE_CEO = keccak256(abi.encode("CEO"));
    bytes32 public constant ROLE_CFO = keccak256(abi.encode("CFO"));
    bytes32 public constant ROLE_CTO = keccak256(abi.encode("CTO"));
    bytes32 public constant ROLE_COO = keccak256(abi.encode("COO"));
    bytes32 public constant ROLE_CMO = keccak256(abi.encode("CMO"));
    bytes32 public constant ROLE_ADVISOR = keccak256(abi.encode("ADVISOR"));
    bytes32 public constant ROLE_PARTNER = keccak256(abi.encode("PARTNER"));
    bytes32 public constant ROLE_HOLDER = keccak256(abi.encode("HOLDER"));

    mapping(string => bytes32) private _stringToRole;
    mapping(bytes32 => string) private _roleToString;

    string[] _rolesStr;

    address private _aclOwner;


    bytes32[] private DirectorRoles;
    bytes32[] private OtherRoles;

    mapping (string => address) private _locations;

    bool internal initialized = false;

    mapping (address => mapping(address => bool)) private _canAccess;

    function _initACL() public onlyOwner onlyUninitialized {
        DirectorRoles[0] = keccak256(abi.encode("NONE"));
        DirectorRoles[1] = ROLE_CEO;
        DirectorRoles[2] = ROLE_CFO;
        DirectorRoles[3] = ROLE_CTO;
        DirectorRoles[4] = ROLE_COO;
        DirectorRoles[5] = ROLE_CMO;
        OtherRoles[0] = keccak256(abi.encode("NONE"));
        OtherRoles[1] = ROLE_ADVISOR;
        OtherRoles[2] = ROLE_PARTNER;
    }

    function _setRolesMapping() private onlyOwner onlyUninitialized {
        _stringToRole["CEO"] = ROLE_CEO;
        _stringToRole["CFO"] = ROLE_CFO;
        _stringToRole["CTO"] = ROLE_CTO;
        _stringToRole["COO"] = ROLE_COO;
        _stringToRole["CMO"] = ROLE_CMO;
        _stringToRole["ADVISOR"] = ROLE_CMO;
        _stringToRole["PARTNER"] = ROLE_CMO;
        _stringToRole["HOLDER"] = ROLE_CMO;
        _rolesStr = ["CEO", "CFO", "CTO", "COO", "CMO", "ADVISOR", "PARTNER", "HOLDER"];

        _roleToString[ROLE_CEO] = "CEO";
        _roleToString[ROLE_CFO] = "CFO";
        _roleToString[ROLE_CTO] = "CTO";
        _roleToString[ROLE_COO] = "COO";
        _roleToString[ROLE_CMO] = "CMO";
        _roleToString[ROLE_ADVISOR] = "ADVISOR";
        _roleToString[ROLE_PARTNER] = "PARTNER";
        _roleToString[ROLE_HOLDER] = "HOLDER";

    }

    function getAllDirectorRoles() public view returns(bytes32[] memory) {
        return DirectorRoles;
    }

    function getAllDirectorRolesAsHumanReadable() public view returns(string[] memory) {
       return _rolesStr;
    }

    function addRoleToAddress(bytes32 role, address _to) public onlyAclOwner {
       grantRole(role, _to);
    }

    modifier onlyUninitialized() {
        require(initialized == false, "already initialized");
        _;
    }

    modifier onlyAclOwner() {
        require(msg.sender == AclOwner(), "only acl owner");
        _;
    }

    function _setAclOwner(address __aclOwner) private {
        _aclOwner = __aclOwner;
    }

    function AclOwner() public view  returns(address) {
        return _aclOwner;
    }

}
