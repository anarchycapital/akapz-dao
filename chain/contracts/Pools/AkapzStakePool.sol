// SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "./AkapzPoolStorage.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";
import {Akapz} from "../Governance/Akapz.sol"; // Governance Token
import {AKX} from "../AKX/AKX.sol";
import {IWETH} from "@uniswap/v2-periphery/contracts/interfaces/IWETH.sol";
import {UniswapV2Library} from "@uniswap/v2-periphery/contracts/libraries/UniswapV2Library.sol";
import {IUniswapV2Factory} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import {IUniswapV2Router02} from "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import {IUniswapV2Pair} from "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import {AkapzFarmingLPToken} from "./AkapzFarmingLPToken.sol";


contract AkapzStakePool is AkapzPoolStorage {
    using SafeMath for uint256;
    using SafeERC20 for IERC20;
    using SafeERC20 for AKX;

    AKX public AKXToken;
    AkapzFarmingLPToken public akapzFarmingLPToken;
    Akapz public AkapzGovernanceToken;
    IWETH public wETH;
    IUniswapV2Factory public uniswapV2Factory;
    IUniswapV2Router02 public uniswapV2Router02;

    address AKX_TOKEN;
    address AKAPZ_GOVERNANCE_TOKEN;
    address WETH_TOKEN;
    address UNISWAP_V2_FACTORY;
    address UNISWAP_V2_ROUTER_02;

    uint8 public currentStakeId;

    uint totalStakedLPTokenAmount;        /// Total staked UNI-LP tokens (AKX-ETH) amount during whole period
    uint lastTotalStakedLPTokenAmount;    /// Total staked UNI-LP tokens (AKX-ETH) amount until last week
    uint weeklyTotalStakedLPTokenAmount;  /// Total staked UNI-LP tokens (AKX-ETH) amount during recent week

    uint public startBlock;
    uint public lastBlock;
    uint public nextBlock;

    uint256 REWARD_RATE = 15; // reward rate is 15%

    constructor(AKX _AKXToken,
        Akapz _akapzGovernanceToken,
        IUniswapV2Factory _uniswapV2Factory,
        IUniswapV2Router02 _uniswapV2Router02
    ) {
        AKXToken = _AKXToken;
        AkapzGovernanceToken = _akapzGovernanceToken;
        uniswapV2Factory = _uniswapV2Factory;
        uniswapV2Router02 = _uniswapV2Router02;
        wETH = IWETH(uniswapV2Router02.WETH());
        AKX_TOKEN = address(_AKXToken);
        AKAPZ_GOVERNANCE_TOKEN = address(_akapzGovernanceToken);
        UNISWAP_V2_FACTORY = address(_uniswapV2Factory);
        UNISWAP_V2_ROUTER_02 = address(_uniswapV2Router02);
        WETH_TOKEN = address(uniswapV2Router02.WETH());

        startBlock = block.number;
        lastBlock = block.number;

    }

    // Create erc20 pair addresses of LP Tokens AKX / ERC20Token

    function createPairWithERC20(IERC20 erc20) public returns (IUniswapV2Pair pair) {
        address pair = uniswapV2Factory.createPair(AKX_TOKEN, address(erc20));
        return IUniswapV2Pair(pair);
    }

    // Create pairing with ETH / WETH
    function createPairWithETH() public returns (IUniswapV2Pair pair) {
        address pair = uniswapV2Factory.createPair(AKX_TOKEN, WETH_TOKEN);  /// [Note]: WETH is treated as ETH
        return IUniswapV2Pair(pair);
    }

    // Add liquidity AKX Tokens with ERC20 tokens

    function addLiquidityWithERC20(
    IUniswapV2Pair pair,
    uint256 AKXTokenAmountDesired,
    uint256 ERC20AmountDesired
    ) public  {
        IERC20 erc20 = IERC20(pair.token1());
        AKXToken.safeTransfer( msg.sender, AKXTokenAmountDesired);
        erc20.safeTransfer(msg.sender, ERC20AmountDesired);
        /// Check whether a pair contract exists or not
        address pairAddress = uniswapV2Factory.getPair(AKX_TOKEN, address(erc20));
        require (pairAddress > address(0), "This pair contract has not existed yet");

        IUniswapV2Pair pair = IUniswapV2Pair(UniswapV2Library.pairFor(UNISWAP_V2_FACTORY, AKX_TOKEN, address(erc20)));
        uint totalSupply = pair.totalSupply();
        require (totalSupply > 0, "This pair's totalSupply is still 0. Please add liquidity at first");

        /// Approve each tokens for UniswapV2Router02
        AKXToken.safeApprove(UNISWAP_V2_ROUTER_02, AKXTokenAmountDesired);
        erc20.safeApprove(UNISWAP_V2_ROUTER_02, ERC20AmountDesired);

        uint256 AKXTokenAmount;
        uint256 ERC20Amount;
        uint256 liquidity;
        (AKXTokenAmount, ERC20Amount, liquidity) = _addLiquidityWithERC20(erc20, AKXTokenAmountDesired, ERC20AmountDesired);

        // minting from lp farming


        /// Back LPtoken to a staker
        pair.transfer(msg.sender, liquidity);

    }

    function _addLiquidityWithERC20(   /// [Note]: This internal method is added for avoiding "Stack too deep"
        IERC20 erc20,
        uint256 AKXTokenAmountDesired,
        uint256 ERC20AmountDesired
    ) internal returns (uint256 _AKXTokenAmount, uint256 _ERC20Amount, uint256 _liquidity) {
        uint256 AKXTokenAmount;
        uint256 ERC20Amount;
        uint256 liquidity;

        /// Define each minimum amounts
        uint256 AKXTokenMin;
        uint256 ERC20AmountMin;

        address to = msg.sender;
        uint deadline = block.timestamp.add(15 seconds);
        (AKXTokenAmount, ERC20Amount, liquidity) = uniswapV2Router02.addLiquidity(AKX_TOKEN,
            address(erc20),
            AKXTokenAmountDesired,
            ERC20AmountDesired,
            AKXTokenMin,
            ERC20AmountMin,
            to,
            deadline);

        return (AKXTokenAmount, ERC20Amount, liquidity);
    }

    /***
   * @notice - Add Liquidity for a pair (LP token) between the AKX tokens and ETH (AKX/ETH)
     **/
    function addLiquidityWithETH(
        IUniswapV2Pair pair,
        uint AKXTokenAmountDesired
    ) public payable  {
        /// Transfer AKX tokens and ETH from a user
        AKXToken.safeTransfer(msg.sender, AKXTokenAmountDesired);
        uint ETHAmountMin = msg.value;

        /// Convert ETH (msg.value) to WETH (ERC20) 
        /// [Note]: Converted amountETH is equal to "msg.value"
        wETH.deposit();

        /// Approve each tokens for UniswapV2Routor02
        AKXToken.approve(UNISWAP_V2_ROUTER_02, AKXTokenAmountDesired);
        //wETH.approve(UNISWAP_V2_ROUTER_02, ETHAmountMin);

        /// Add liquidity and pair
        uint AKXTokenAmount;
        uint ETHAmount;
        uint liquidity;
        (AKXTokenAmount, ETHAmount, liquidity) = _addLiquidityWithETH(AKXTokenAmountDesired, ETHAmountMin);

        /// [Todo]: Refund leftover ETH to a staker (Need to identify how much leftover ETH of a staker) 
        //msg.sender.call.value(address(this).balance)("");

        /// Back LPtoken to a staker
        pair.transfer(msg.sender, liquidity);

    }

    function _addLiquidityWithETH(   /// [Note]: This internal method is added for avoiding "Stack too deep" 
        uint AKXTokenAmountDesired,
        uint ETHAmountMin
    ) internal returns (uint _AKXTokenAmount, uint _ETHAmount, uint _liquidity) {
        uint AKXTokenAmount;
        uint ETHAmount;
        uint liquidity;

        /// Define each minimum amounts
        uint AKXTokenMin = AKXTokenAmountDesired;  /// [Note]: 5 AKX will be set as the initial addLiquidity.

        address to = msg.sender;
        uint deadline = block.timestamp.add(300 seconds);
        (AKXTokenAmount, ETHAmount, liquidity) = uniswapV2Router02.addLiquidityETH(AKX_TOKEN,
            AKXTokenAmountDesired,
            AKXTokenMin,
            ETHAmountMin,
            to,
            deadline);

        return (AKXTokenAmount, ETHAmount, liquidity);
    }

    ///------------------------------------------------------------------------------
    /// Remove liquidity AKX tokens with ERC20 tokens (AKX/DAI, AKX/USDC, etc...)
    ///------------------------------------------------------------------------------

    /***
     * @notice - Remove liquidity" for a pair (LP token) between the AKX tokens and another ERC20 tokens 
     *         - e.g. AKX/DAI, AKX/USDC, etc...
     **/
    function removeLiquidityWithERC20(address staker, IUniswapV2Pair pair, uint lpTokenAmountUnStaked) internal  {
        /// Remove liquidity that a staker was staked
        uint AKXTokenAmount;
        uint ERC20Amount;
        uint AKXTokenMin = 0;
        uint ERC20AmountMin = 0;
        address to = staker;
        uint deadline = block.timestamp.add(15 seconds);
        (AKXTokenAmount, ERC20Amount) = uniswapV2Router02.removeLiquidity(AKX_TOKEN,
            pair.token1(),
            lpTokenAmountUnStaked,
            AKXTokenMin,
            ERC20AmountMin,
            to,
            deadline);

        /// Transfer AKX token and ERC20 + fees earned (into a staker)
        AKXToken.transfer(staker, AKXTokenAmount);
        IERC20(pair.token1()).transfer(staker, ERC20Amount);
    }


    ///-------------------------------------------------------------------
    /// Remove Liquidity AKX tokens with ETH (AKX/ETH)
    ///-------------------------------------------------------------------

    /***
     * @notice - Remove liquidity for a pair (LP token) between the AKX tokens and ETH (AKX/ETH)
     **/
    function removeLiquidityWithETH(address payable staker, IUniswapV2Pair pair, uint lpTokenAmountUnStaked) public  {
        /// Remove liquidity that a staker was staked
        uint AKXTokenAmount;
        uint ETHAmount;         /// WETH
        uint AKXTokenMin = 0;
        uint ETHAmountMin = 0;  /// WETH
        address to = staker;
        uint deadline = block.timestamp.add(15 seconds);
        (AKXTokenAmount, ETHAmount) = uniswapV2Router02.removeLiquidityETH(AKX_TOKEN,
            lpTokenAmountUnStaked,
            AKXTokenMin,
            ETHAmountMin,
            to,
            deadline);

        /// Convert WETH to ETH
        wETH.withdraw(ETHAmount);

        /// Transfer AKX token and ETH + fees earned (into a staker)
        AKXToken.transfer(staker, AKXTokenAmount);
        staker.transfer(ETHAmount);
    }

    ///--------------------------------------------------------
    /// Stake UNI-LP tokens of AKX/ERC20 or AKX/ETH into AKX pool
    ///--------------------------------------------------------

    /***
     * @notice - Stake UNI-LP tokens (AKX/ERC20 or AKX/ETH)
     * @param pair - Staked UNI-LP token
     * @param lpTokenAmount - Staked UNI-LP tokens amount
     **/
    function stakeLPToken(IUniswapV2Pair pair, uint lpTokenAmount) public {
        /// Stake LP tokens into this pool contract
        pair.transferFrom(msg.sender, address(this), lpTokenAmount);

        /// Mint the akapz Farming LP tokens
        akapzFarmingLPToken.mint(msg.sender, lpTokenAmount);

        /// Add new staked UNI-LP token amount to the total staked UNI-LP token amount
        totalStakedLPTokenAmount += lpTokenAmount;

        /// Register staker's data
        uint8 newStakeId = getNextStakeId();
        currentStakeId++;
        StakeData storage stakeData = stakeDatas[newStakeId];
        stakeData.staker = msg.sender;
        stakeData.lpToken = pair;
        stakeData.stakedLPTokenAmount = lpTokenAmount;
        stakeData.startBlock = block.number;

        /// Staker is added into stakers list
        stakersList.push(msg.sender);

        /// Save stake ID
        Staker storage staker = stakers[msg.sender];
        staker.stakeIds.push(newStakeId);
    }


    ///---------------------------------------------------
    /// Withdraw only earned rewards
    ///---------------------------------------------------

    /***
     * @notice - Claim rewards (Do not un-stake LP tokens (GLM-ETH)
     * @dev - Caller (msg.sender) is a staker
     **/
    function claimEarnedReward(IUniswapV2Pair pair) public  {
        /// Compute earned rewards (akapzGovernanceToken) and Distribute them into a staker
        uint earnedReward = _computeEarnedReward(pair);

        /// Mint akapzGovernanceToken as rewards for a staker
        AkapzGovernanceToken.mint(msg.sender, earnedReward);
    }

    ///---------------------------------------------------
    /// Regular update of pool status
    ///---------------------------------------------------

    /***
     * @notice - Update pool status weekly (every week)
     **/
    function weeklyPoolStatusUpdate() public  {
        uint currentBlock = block.number;

        if (currentBlock > nextBlock) {
            require (currentBlock > lastBlock, "Block number is still in the last period");

            /// Update both blocks (the last block and the next block)
            lastBlock = currentBlock;
            nextBlock = currentBlock.add(604800);  /// Plus 1 week (604800 seconds)

            /// Update total staked amount until last week
            _updateLastTotalStakedLPTokenAmount();
        }

    }

    ///---------------------------------------------------
    /// Withdraw UNI-LP tokens with earned rewards
    ///---------------------------------------------------

    /***
     * @notice - un-stake LP tokens with earned rewards (akapzGovernanceToken)
     * @dev - Caller (msg.sender) is a staker
     **/
    function unStakeLPToken(IUniswapV2Pair pair, uint unStakedLpTokenAmount) public  {
        address PAIR = address(pair);

        /// Burn the akapz Farming Tokens and transfer un-staked LP tokens
        _redeemWithUnStakedLPToken(msg.sender, pair, unStakedLpTokenAmount);

        /// Compute earned reward (akapzGovernanceToken) and Distribute them into staker
        claimEarnedReward(pair);
    }

    function _redeemWithUnStakedLPToken(address staker, IUniswapV2Pair pair, uint unStakedLpTokenAmount) internal  {
        /// Burn the akapz Farming LP tokens
        akapzFarmingLPToken.burn(staker, unStakedLpTokenAmount);

        /// Transfer un-staked UNI-LP tokens
        pair.transfer(staker, unStakedLpTokenAmount);
    }

    ///--------------------------------------------------------
    /// akapz Governance Token is given to stakers as rewards
    ///--------------------------------------------------------

    /***
     * @notice - Compute earned rewards that is akapzGovernanceTokens
     * @dev - [idea v1]: Reward is given to each stakers every block (every 15 seconds) and depends on share of pool
     * @dev - [idea v2]: Reward is given to each stakers by using the fixed-rewards-rate (10%)
     *                   => There is the locked-period (7 days) as minimum staking-term.
     **/
    function _computeEarnedReward(IUniswapV2Pair pair) internal returns (uint _earnedReward) {
        Staker memory staker = stakers[msg.sender];
        uint8[] memory _stakeIds = staker.stakeIds;
        uint totalIndividualStakedLPTokenAmount;

        for (uint8 i=1; i < _stakeIds.length; i++) {
            uint8 stakeId = i;

            StakeData memory stakeData = stakeDatas[stakeId];
            IUniswapV2Pair _pair = stakeData.lpToken;
            uint stakedLPTokenAmount = stakeData.stakedLPTokenAmount;

            totalIndividualStakedLPTokenAmount += stakedLPTokenAmount;
        }

        /// Identify each staker's share of pool
        uint SHARE_OF_POOL = totalIndividualStakedLPTokenAmount.div(totalStakedLPTokenAmount);

        /// Compute total staked GLM tokens amount per a week (7days)
        weeklyTotalStakedLPTokenAmount = totalStakedLPTokenAmount.sub(lastTotalStakedLPTokenAmount);

        /// Formula for computing earned rewards (akapzGovernanceTokens)
        uint earnedReward = weeklyTotalStakedLPTokenAmount.mul(REWARD_RATE).div(100).mul(SHARE_OF_POOL).div(100);

        return earnedReward;
    }

    /***
     * @notice - Update total staked amount until last week
     **/
    function _updateLastTotalStakedLPTokenAmount() internal {
        lastTotalStakedLPTokenAmount = totalStakedLPTokenAmount;
    }

    ///-------------------
    /// Other getter methods
    ///-------------------

    function getTotalStakedLPTokenAmount() public view returns (uint _totalStakedLPTokenAmount) {
        return totalStakedLPTokenAmount;
    }

    function getTotalIndividualStakedLPTokenAmount(uint8 stakeId) public view returns (uint _totalIndividualStakedLPTokenAmount) {
        StakeData memory stakeData = stakeDatas[stakeId];
        return stakeData.stakedLPTokenAmount;
    }


    ///-------------------
    /// Private methods
    ///-------------------

    function getNextStakeId() private view returns (uint8 nextStakeId) {
        return currentStakeId + 1;
    }


}