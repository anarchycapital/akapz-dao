// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "../Base/BaseMediaNFT.sol";
import "../Libraries/Media.sol";

contract ImageNFT is BaseMediaNft {

    Media.ImageDetails private _image;

    constructor(string memory prefix, string memory name, string memory symbol, Media.ImageDetails memory details) BaseMediaNft(prefix, name, symbol)  {

        _image = Media.newImage(details);

    }

}