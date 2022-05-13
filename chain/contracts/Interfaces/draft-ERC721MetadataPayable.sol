// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Libraries/Media.sol";

abstract contract ERC721MetadataPayable is Ownable {

    struct Metadata {
        address creator;
        string mediaID;
        string ipfsBase;
        string previewImage;
        string previewVideo;
        address itemAddress;
        bytes32 mediaType;
        bool isBuyable;
        bool oneTimePayment;
        bool ppv;
        bool liveStream;
        bool unique;
        uint qtyAvailable;
    }

    mapping (address => Metadata) private _metadataPayable;
    mapping (address => bool) private _buyers;

    function Creator(address _nft) public view virtual returns (address) {
        return _getMetaDataPayable(_nft).creator;
    }

    function PreviewImage(address _nft) public view virtual returns (string) {
        return _getMetaDataPayable(_nft).previewImage;
    }

    function MediaType(address _nft) public view virtual returns (string) {
        return _getMetaDataPayable(_nft).mediaType;
    }


    function PreviewVideo(address _nft) public view virtual returns (string) {
        return _metadataPayable[_nft].previewVideo;
    }

    function _getMetaDataPayable(address _nft) private returns (Metadata) {
        return _metadataPayable[_nft];
    }

    function setMetadata(address _nft, Metadata _data) public onlyOwner {
        _metadataPayable[_nft] = _data;
    }

    function _beforeCreate() private {}
    function _afterCreate() private {}

    function _beforeGet() private {}
    function _afterGet() private {}


    modifier onlyBuyer(address _sender) {
        require(_buyers[_sender] == true, "please purchase this nft before doing this");
        _;
    }

}