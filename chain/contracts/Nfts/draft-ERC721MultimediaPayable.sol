// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "../Libraries/Media.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
abstract contract ERC721MultiMediaPayable is ERC721, ERC721URIStorage, Ownable {


    address private _beneficiary;

    using SafeERC20 for ERC20;

    event NFTBought(address indexed _nftToken, address indexed _from, address indexed _to, uint256 amount, address currency);
    event NFTViewed(address indexed _nftToken, uint timestamp, bool _freeView);

    uint private _views = 0;
    uint private _freeViews = 0;
    uint private _boughtNumTimes = 0;

    address private _creator;
    address private _owner;

    bytes32 private _mediaType;

    string previewURI;

    bytes32[] _allCurrencies;


    struct BoughtItem {
        address _internalID;
        string ipfsHash;
        uint256 amount;
        uint timestamp;
        uint tokenId;
    }

    uint256 private price;
    uint256 private priceType;

    using Counters for Counters.Counter;

    Counters.Counter private _currentIds;


    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
    }

    mapping (address => bool) private _buyer;
    ERC20[] private _acceptedERC20Tokens;


    function setAcceptedCurrencies(address[] memory tokens) public onlyOwner {
        uint i = 0;
        for (i == 0; i < tokens.length; i++) {
            _acceptedERC20Tokens[i] = ERC20(tokens[i]);
        }
    }

    function getAcceptedCurrencies() public returns(bytes32[] memory) {
        uint i = 0;

        for (i == 0; i < _acceptedERC20Tokens.length; i++) {
            _allCurrencies[i] = keccak256(abi.encode(_acceptedERC20Tokens[i].name()));
        }
        return _allCurrencies;
    }

    function Creator() public view virtual returns (address) {
        return _creator;
    }

    function PreviewImage() public view virtual returns (string memory) {
        return previewURI;
    }

    function MediaType() public view virtual returns (bytes32) {
        return _mediaType;
    }

    function IsImageMediaType() public view virtual returns(bool) {
        return _mediaType == Media.MEDIA_TYPE_IMAGE || _mediaType == Media.MEDIA_TYPE_FREEBIE_IMAGE;
    }

    function IsVideoMediaType() public view virtual returns(bool) {
        return _mediaType == Media.MEDIA_TYPE_VIDEO|| _mediaType == Media.MEDIA_TYPE_FREEBIE_VIDEO;
    }

    function IsStreamMediaType() public view virtual returns(bool) {
        return _mediaType == Media.MEDIA_TYPE_FREEBIE_STREAM || _mediaType == Media.MEDIA_TYPE_PPMS ||
        _mediaType == Media.MEDIA_TYPE_PPVS;
    }


    function PreviewVideo() public view virtual returns (string memory) {
        return previewURI;
    }


    function _beforeCreate() private {}
    function _afterCreate() private {}

    function _beforeGet() private {}
    function _afterGet() private {}


    modifier onlyBuyer(uint _itemId, address _sender) {
        require(_buyer[_sender] == true, "please purchase this nft before doing this");
        _;
    }


    function safeMint(address to, string memory _uri) public onlyOwner {
        uint256 tokenId = _currentIds.current();
        _currentIds.increment();
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
        require(msg.value >= price, "not enough value sent");
        uint256 newItemId = _currentIds.current();
        _currentIds.increment();
      //  _existingURIs[metadataURI] = 1;
        _mint(to, newItemId);
        _setTokenURI(newItemId, metadataURI);
        return newItemId;
    }

}