// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./AKX.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AKXTFaucet is Ownable {
    AKX public token;
    function setAKXT(address _token) external onlyOwner {
        // can be called only once
        require(address(token) == address(0), "Function can be invoked only once");

        // validate address
        require(_token != address(0), "Invalid token contract address");

        token = AKX(_token);
    }

    function create() external {
        require(address(token) != address(0), "Token contract has not been set");
        uint256 tokens = 1000 * 10 ** uint256(token.decimals());
        if (token.balanceOf(msg.sender) >= tokens) revert("Cannot acquire more funds");
        require(token.mint(msg.sender, tokens), "Failed to create funds");
    }
}