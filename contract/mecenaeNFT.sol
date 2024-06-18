// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract MecenaeNFT is ERC721URIStorage {
   
    uint256 private _tokenIds;
    mapping(uint256 => uint256) public tokenPrice;

    constructor() ERC721("MecenaeNFT", "MCN") {}

    function mintNFT(address recipient, string memory name, string memory eventName, string memory eventDate, string memory description, string memory picture)
        public returns (uint256)
    {
        _tokenIds += 1;

        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, encodeMetadata(name, eventName, eventDate, description, picture));

        return newItemId;
    }

    function encodeMetadata(string memory name, string memory eventName, string memory eventDate, string memory description, string memory picture)
        internal pure returns (string memory)
    {
        // Encode the metadata into a JSON format or use a service like IPFS to store metadata
        return string(abi.encodePacked(name, eventName, eventDate, description, picture));
    }

    function buyNFT(uint256 tokenId) public payable {
        require(tokenPrice[tokenId] > 0, "This token is not for sale.");
        require(msg.value >= tokenPrice[tokenId], "Insufficient funds to purchase.");

        address seller = ownerOf(tokenId);
        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(msg.value);
        tokenPrice[tokenId] = 0; // Token is no longer for sale
    }

    function sellNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner.");
        tokenPrice[tokenId] = price;
    }

    function tradeNFT(uint256 tokenId, address to) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner.");
        
        _transfer(msg.sender, to, tokenId);
    }
}
