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