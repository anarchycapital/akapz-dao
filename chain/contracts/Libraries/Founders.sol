// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

library Founders {

    struct foundersData {
        string name;
        bytes32 roles;
        address wallet;
    }

    function _createFounder(string memory name, bytes32  roles, address wallet) public pure returns (foundersData memory) {
        return foundersData({
            name: name,
            roles: roles,
            wallet: wallet
        });
    }

}