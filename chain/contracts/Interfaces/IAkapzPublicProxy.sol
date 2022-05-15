//SPDX-License-Identifier: MIT
pragma solidity 0.8.9;

import { IERC20 as ERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { Akapz as IAkapz} from "../Governance/Akapz.sol";
import "../Governance/Governor.sol";

interface IAkapzPublicProxy {

    function getExpectedRate(ERC20 src, ERC20 dst, uint srcQty) external view returns(uint expectedRate, uint slippageRate);
    function convertToFiat(ERC20 src, uint fiatID) external view returns(uint conversion);
    function getInfo(uint256 _tokenId) external view returns(uint info);
    function swapPreview(ERC20 src, ERC20 dst, uint srcQty) external view returns(uint dstQty);

}