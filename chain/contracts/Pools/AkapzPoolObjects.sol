// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../../v2-core/contracts/interfaces/IUniswapV2Pair.sol";

contract AkapzPoolObjects {

    struct Staker {
        uint8[] stakeIds;
        uint256 amount;
        uint256 rewardDebt;
        uint blockTs;
    }

    struct StakeData {
        address staker;
        IUniswapV2Pair lpToken;
        uint256 stakedLPTokenAmount;
        uint256 startBlock;
        uint256 shareOfPool;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accPerShare;
    }

    struct Pool {
        IUniswapV2Pair lpToken;
        uint256 allocPoint;
        uint256 lastRewardBlock;
        uint256 accPerShare;
    }

}