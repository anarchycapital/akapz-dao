// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./AkapzPoolObjects.sol";

contract AkapzPoolStorage is AkapzPoolObjects {
    mapping (address => Staker) public stakers; // Key: Stake Address
    address[] stakersList;

    mapping(uint8 => StakeData) public stakeDatas; // Key: StakeID

    mapping(address => Pool) public pools; // Key: LP Token Address
}