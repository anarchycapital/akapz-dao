//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import "../Libraries/FeeDistribution.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/finance/PaymentSplitter.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";


abstract contract Fees is Initializable {


    using Counters for Counters.Counter;

    Counters.Counter private _period;

    uint private constant _periodDuration = 1 hours;
    uint private constant _blockDuration = 2 seconds;
    uint private constant _blockPerPeriod = 1800;

    uint public current_period = 1;

    bool private period_initialized = false;

    uint private timeSinceStart = 0;

    uint private startedAtBlock;

    uint256 private _totalFeesReceived;

    event LogFeeDistributed(address _to, uint256 _amount, uint256 _percentOfTotal, uint _atBlock, uint _period);

    mapping(address => FeeDistribution.HolderFees) private _holdersToFees;
    mapping(address => bool) private _distStatus;

    address _tokenAddress;

    PaymentSplitter private _splitter;

    function __Fees_Init() internal onlyInitializing {

    }

    function _calculateFeeToDistribute(address _to, uint _percent) internal returns (uint256) {
        return FeeDistribution.calcFeesToDistribute(_totalFeesReceived, _percent);
    }

    function _setHolder(address _to, uint _percent) private {
        _holdersToFees[_to] = FeeDistribution.HolderFees({
        percent: _percent,
        feesToDistribute: _calculateFeeToDistribute(_to, _percent),
        distributed: false,
        period: current_period
        });
        _distStatus[_to] = false;
    }




}