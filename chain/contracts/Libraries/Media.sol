// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;


library Media {

 struct ImageDetails {
        string mimeType;
        uint size;
        uint heightPx;
        uint widthPx;
        bool _censoredIfNotPurchased;
        bool _isNSFW;
        string title;
        string _description;
        uint _timestamp;
        uint _expiry;
    }

     struct VideoDetails {
        string mimeType;
        uint size;
        uint heightPx;
        uint widthPx;
        bool _hasPreview;
        bool _isNSFW;
        string title;
        string _description;
        uint durationInSeconds;
        uint _timestamp;
        uint _expiry;
    }

    bytes32 public constant MEDIA_TYPE_IMAGE = keccak256(abi.encode("IMAGE"));
    bytes32 public constant MEDIA_TYPE_VIDEO = keccak256(abi.encode("VIDEO"));
    bytes32 public constant MEDIA_TYPE_PPMS = keccak256(abi.encode("PPMS"));
    bytes32 public constant MEDIA_TYPE_PPVS = keccak256(abi.encode("PPMS"));
    bytes32 public constant MEDIA_TYPE_FREEBIE_IMAGE = keccak256(abi.encode("FREEBIE_IMAGE"));
    bytes32 public constant MEDIA_TYPE_FREEBIE_VIDEO = keccak256(abi.encode("FREEBIE_VIDEO"));
    bytes32 public constant MEDIA_TYPE_FREEBIE_STREAM = keccak256(abi.encode("FREEBIE_STREAM"));

    function newImage(ImageDetails calldata _image) external  pure returns(ImageDetails memory) {
        return ImageDetails({
            mimeType: _image.mimeType,
            size: _image.size,
            heightPx: _image.heightPx,
            widthPx: _image.widthPx,
            _censoredIfNotPurchased: _image._censoredIfNotPurchased,
            _isNSFW: _image._isNSFW,
             title: _image.title,
              _description: _image._description,
              _timestamp: _image._timestamp,
              _expiry: _image._expiry
        });
    }

}