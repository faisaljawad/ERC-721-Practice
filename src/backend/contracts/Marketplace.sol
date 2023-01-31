// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract Marketplace is ReentrancyGuard {
    // State Variables
    address payable public immutable feeAccount; // The account that received fees
    uint256 public immutable feePercent; // The fee percentage on sales
    uint256 public itemCount;

    struct Item {
        uint256 itemId;
        IERC721 nft;
        uint256 tokenId;
        uint256 price;
        address payable seller;
        bool sold;
    }
    
    event Offered(
        uint itemid,
        address indexed,
        uint tokenId,
        uint price,
        address indexed seller
    );

    // itemId -> item
    mapping(uint256 => Item) public items;

    constructor(uint256 _feePercentage) {
        feeAccount = payable(msg.sender);
        feePercent = _feePercentage;
    }

    function makeItem(IERC721 _nft, uint256 _tokenId, uint256 _price) external nonReentrant {
        require(_price > 0, "Price must be greater than zero");
        itemCount += 1;
        _nft.transferFrom(msg.sender, address(this), _tokenId);
        // add new item to items mapping
        items[itemCount] = Item (itemCount, _nft, _tokenId, _price, payable(msg.sender), false);
        // emit Offered event
        emit Offered(itemCount, address(_nft), _tokenId, _price, msg.sender);

    }
}
