// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "base64-sol/base64.sol";

contract SVGNFT is ERC721URIStorage {
   
   uint256 public tokenCounter;
   event CreatedSVGNFT(uint256 indexed tokenId, string tokenURI);

   constructor() ERC721("SVG NFT", "svgNFT"){
       tokenCounter = 0;
   }

   function create(string memory svg) public{
       _safeMint(msg.sender, tokenCounter);
       string memory imageUri = svgToImageURI((svg));
       string memory tokenUri = formatTokenUri(imageUri);
       _setTokenURI(tokenCounter, tokenUri);
       emit CreatedSVGNFT(tokenCounter, tokenUri);
       tokenCounter = tokenCounter+1;
   }

   function svgToImageURI(string memory svg) public pure returns(string memory){

       string memory baseURL = "data:image/svg+xml;base64,";
       string memory svgBase64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
    //    concatenate baseURL with svgBaseEncoded
       string memory imageUri = string(abi.encodePacked(baseURL, svgBase64Encoded));
       return imageUri;
   }

   function formatTokenUri(string memory imageURI) public pure returns(string memory){

       return string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                "SVG NFT", // You can add whatever name here
                                '", "description":"An NFT based on SVG!", "attributes":"brilliance", "image":"',imageURI,'"}'
                            )
                        )
                    )
                )
            );
   }
}