// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library Founders {


    bytes32 public constant ROLE_CEO = keccak256(abi.encode("CEO"));
    bytes32 public constant ROLE_CFO = keccak256(abi.encode("CFO"));
    bytes32 public constant ROLE_CTO = keccak256(abi.encode("CTO"));
    bytes32 public constant ROLE_COO = keccak256(abi.encode("COO"));
    bytes32 public constant ROLE_CMO = keccak256(abi.encode("CMO"));
    bytes32 public constant ROLE_ADVISOR = keccak256(abi.encode("ADVISOR"));
    bytes32 public constant ROLE_PARTNER = keccak256(abi.encode("PARTNER"));

    struct founderData {
        string name;
        bytes32 roles;
        address wallet;
    }

    function _createFounder(string memory name, bytes32  roles, address wallet) public pure returns (founderData memory) {
        return founderData({
            name: name,
            roles: roles,
            wallet: wallet
        });
    }

    function _roleToString(bytes32 role) public pure returns (string memory) {
        if(role == ROLE_CEO) return "CEO";
        if(role == ROLE_CFO) return "CFO";
        if(role == ROLE_CTO) return "CTO";
        if(role == ROLE_COO) return "COO";
        if(role == ROLE_CMO) return "CMO";
        if(role == ROLE_ADVISOR) return "ADVISOR";
        if(role == ROLE_PARTNER) return "PARTNER";
       return "";
    }

}