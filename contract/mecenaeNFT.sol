// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract MecenaeNFT is ERC721URIStorage {
   
    uint256 private _tokenIds;
    mapping(uint256 => uint256) public tokenPrice;


    constructor() ERC721("MecenaeNFT2", "MCN") {}

    function mintNFT(address recipient, string memory name, string memory description, string memory image)
        public returns (uint256)
    {
        _tokenIds += 1;
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, encodeMetadata(name, description, image));

        return newItemId;
    }

    function encodeMetadata(string memory name, string memory description, string memory image)
        internal pure returns (string memory)
    {
        // Encode the metadata into a JSON format or use a service like IPFS to store metadata
        return string(
            abi.encodePacked(
                '{"name":"',
                name,
                '",',
                '"description":"',
                description,
                '",',
                '"image":"',
                image,
                '"}'
            )
        );
    }

    function buyNFT(uint256 tokenId) public payable {
        require(tokenPrice[tokenId] > 0, "This token is not for sale.");
        require(msg.value >= tokenPrice[tokenId], "Insufficient funds to purchase.");

        address seller = ownerOf(tokenId);

        uint256 transactionFee = (tokenPrice[tokenId] * 1) / 100; // Calculate 1% transaction fee
        uint256 remainingValue = tokenPrice[tokenId] - transactionFee;

        // Transfer transaction fee to the fixed wallet address (replace with your actual wallet address)
        address feeWallet = 0x91370da2633e5b633588376ab25CdaD93227dc8C;
        payable(feeWallet).transfer(transactionFee);

        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(remainingValue);
        tokenPrice[tokenId] = 0; // Token is no longer for sale
    }

    function sellNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner.");
        tokenPrice[tokenId] = price;
    }
}
