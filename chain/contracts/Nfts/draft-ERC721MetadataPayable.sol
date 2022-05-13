// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Libraries/Media.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
abstract contract ERC721MediaPayable is ERC721, ERC721URIStorage, Ownable {


    address private _beneficiary;

    event NFTBought(address indexed _nftToken, address indexed _from, address indexed _to, uint256 amount, address currency);
    event NFTViewed(address indexed _nftToken, uint timestamp, bool _freeView);

    uint private _views = 0;
    uint private _freeViews = 0;
    uint private _boughtNumTimes = 0;


    struct Metadata {
        address creator;
        string ipfsBase;
        string previewImage;
        string previewVideo;
        bytes32 mediaType;
    }

    struct BoughtItem {
        address _internalID;
        string ipfsHash;
        uint256 amount;
        uint timestamp;
        Metadata _itemMetas;
    }

    uint256 private price;
    uint256 private priceType;

    using Counters for Counters.Counter;

    Counters.Counter private _currentIds;


    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    mapping (address => Metadata) private _metadataPayable;
    mapping (address => bool) private _buyer;
    mapping (address => ERC20) private _acceptedERC20Tokens;


    function Creator(address _nft) public view virtual returns (address) {
        return _getMetaDataPayable(_nft).creator;
    }

    function PreviewImage(address _nft) public view virtual returns (string) {
        return _getMetaDataPayable(_nft).previewImage;
    }

    function MediaType(address _nft) public view virtual returns (string) {
        return _getMetaDataPayable(_nft).mediaType;
    }

    function IsImageMediaType(address _nft) public view virtual returns(bool) {
        return _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_IMAGE || _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_FREEBIE_IMAGE;
    }

    function IsVideoMediaType(address _nft) public view virtual returns(bool) {
        return _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_VIDEO|| _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_FREEBIE_VIDEO;
    }

    function IsStreamMediaType(address _nft) public view virtual returns(bool) {
        return _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_FREEBIE_STREAM || _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_PPMS ||
        _getMetaDataPayable(_nft).mediaType == Media.MEDIA_TYPE_PPVS;
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


    modifier onlyBuyer(uint _itemId, address _sender) {
        require(_buyers[_sender] == true, "please purchase this nft before doing this");
        _;
    }


    function safeMint(address to, string memory _uri) public onlyOwner {
        uint256 tokenId = _tokenIds.current();
        _tokenIds.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, _uri);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    override(ERC721, ERC721URIStorage)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }


    /*
    @dev _buyAMint is when a token is buyable by customers to keep indefinitely for themselves for a ONE TIME FEE
    */
    function _buyAMint(address to, string memory metadataURI) public virtual payable returns (uint256) {
        require(msg.value >= _price, "not enough value sent");
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();
        _existingURIs[metadataURI] = 1;
        _mint(to, newItemId);
        _setTokenURI(newItemId, metadataURI);
        return newItemId;
    }

}