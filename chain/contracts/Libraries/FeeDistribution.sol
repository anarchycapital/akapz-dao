//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

library FeeDistribution {

    struct HolderFees {
        uint percent;
        uint feesToDistribute;
        bool distributed;
        uint period;
    }

    function calcFeesToDistribute(uint256 _totalFees, uint percent) public returns (uint256) {
        uint256 _toPercent = uint256(percent / 100);
        uint256 _feesCalc = _totalFees * _toPercent;
        return _feesCalc;
    }

}