// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";


contract FinalMecenaeNFT is ERC721URIStorage {
   
    uint256 private _tokenIds;
    mapping(uint256 => uint256) public tokenPrice;


    constructor() ERC721("MecenaeNFT2", "MCN") {}

    function mintNFT(address recipient, string memory name, string memory description, string memory image, string memory eventName, string memory eventDate, string memory ngoName)
        public returns (uint256)
    {
        _tokenIds += 1;
        uint256 newItemId = _tokenIds;
        _mint(recipient, newItemId);
        _setTokenURI(newItemId, encodeMetadata(name, description, image, eventName, eventDate, ngoName));
    
        return newItemId;
    }
    
    function encodeMetadata(string memory name, string memory description, string memory image, string memory eventName, string memory eventDate, string memory ngoName)
        internal pure returns (string memory)
    {
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
                '",',
                '"eventName":"',
                eventName,
                '",',
                '"eventDate":"',
                eventDate,
                '",',
                '"ngoName":"',
                ngoName,
                '"}'
            )
        );
    }


    function buyNFT(uint256 tokenId) public payable {
        require(tokenPrice[tokenId] > 0, "This token is not for sale.");
        require(msg.value >= tokenPrice[tokenId], "Insufficient funds to purchase.");

        address seller = ownerOf(tokenId);

        uint256 transactionFee = (tokenPrice[tokenId] * 1) / 100;
        uint256 remainingValue = tokenPrice[tokenId] - transactionFee;

       
        address feeWallet = 0x91370da2633e5b633588376ab25CdaD93227dc8C;
        payable(feeWallet).transfer(transactionFee);

        _transfer(seller, msg.sender, tokenId);
        payable(seller).transfer(remainingValue);
        tokenPrice[tokenId] = 0; 
    }

    function sellNFT(uint256 tokenId, uint256 price) public {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner.");
        tokenPrice[tokenId] = price;
    }

}
