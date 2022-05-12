// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "hardhat-deploy/solc_0.8/proxy/Proxied.sol";
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

abstract contract BaseMediaNft is ERC721, ERC721URIStorage, Ownable, Proxied {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;
     string internal _prefix;

    bytes32 public constant MEDIA_TYPE_IMAGE = keccak256(abi.encode("MEDIA_TYPE_IMAGE"));
    bytes32 public constant MEDIA_TYPE_VIDEO = keccak256(abi.encode("MEDIA_TYPE_VIDEO"));

    struct BaseMediaItem {
        string mediaID;
        string previewImage;
        address itemAddress;
        bytes32 mediaType;
        address creator;
        bool isBuyable;
        bool oneTimePayment;
        bool ppv;
        bool liveStream;
        bool unique;
        uint qtyAvailable;
    }

     function postUpgrade(string memory prefix) public proxied {
        _prefix = prefix;
    }


    uint256 private _price;
    BaseMediaItem private _tokenInfo;

    bool private playable = false;
    bool private downloadable = false;
    bool private viewableBeforeBuying = false;


    mapping(address => bool) private _purchasedNft;
    mapping(string => uint) private _existingURIs;

    constructor(string memory prefix, string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        postUpgrade(prefix);
    }


    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://";
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
    function _buyAMint(address to, string memory metadataURI) public virtual payable buyable  returns (uint256) {
        require(msg.value >= _price, "not enough value sent");
        uint256 newItemId = _tokenIds.current();
        _tokenIds.increment();
        _existingURIs[metadataURI] = 1;
        _mint(to, newItemId);
        _setTokenURI(newItemId, metadataURI);
        return newItemId;
    }

    modifier buyable() {
       require(_tokenInfo.isBuyable == true, "nft not buyable");
       _;
    }

    modifier oneTimePaymentAvailable() {
        require(_tokenInfo.oneTimePayment == true, "cannot buy one time payment");
        _;
    }




}