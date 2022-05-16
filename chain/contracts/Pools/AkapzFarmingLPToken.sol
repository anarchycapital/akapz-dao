// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract AkapzFarmingLPToken is ERC20 {

    string public _name;
    string public _symbol;

    constructor() ERC20("AKX Farming Liquidity Provider Token", "AKLP") {
        _name = "AKX Farming Liquidity Provider Token";
        _symbol = "AKLP";
    }

    function mint(address to, uint mintAmount) public  {
        _mint(to, mintAmount);
    }

    function burn(address to, uint burnAmount) public  {
        _burn(to, burnAmount);
    }

}