// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

// Base64.solコントラクトからSVGとJSONをBase64に変換する関数をインポートします。
import {Base64} from "./lib/Base64.sol";

contract RewardNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg01 =
        "<svg width='600' height='600' viewBox='0 0 600 600' fill='none' xmlns='http://www.w3.org/2000/svg'><style>  .txt {  font-family: 'Roboto', sans-serif;    font-size: 20px;    font-weight: 700;    fill: #000000;  }.title,.id {    font-size: 20px;}  .color {    font-size: 50px;}  </style><rect width='600' height='600' fill='white'/><text    x='50%'    y='15%'    class='title txt'    dominant-baseline='middle'    text-anchor='middle'  >    Many drops make a shower  </text> <circle cx='299.5' cy='240.5' r='101.5' fill='";
    string baseSvg02 =
        "'/><text x='50%' y='65%' class='id txt' dominant-baseline='middle' text-anchor='middle'>#";
    string baseSvg03 =
        "</text><text x='50%' y='80%' class='color txt' dominant-baseline='middle' text-anchor='middle'>";
    string baseSvg04 = "</text></svg>";
    event NewEpicNFTMinted(address sender, uint256 tokenId);
    mapping(address => string[]) public colors;

    constructor() ERC721("colorNFT", "COLOR") {
        console.log("This is my NFT contract.");
    }

    function makeColorNFT(string memory name, string memory rgb16) public {
        uint256 newItemId = _tokenIds.current();
        string memory finalSvg = string(
            abi.encodePacked(
                baseSvg01,
                rgb16,
                baseSvg02,
                Strings.toString(newItemId),
                baseSvg03,
                name,
                baseSvg04
            )
        );
        console.log("\n--------------------");
        console.log(finalSvg);
        console.log("--------------------\n");
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        rgb16,
                        '", "description": "Many drops make a shower.", "image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        console.log("\n----- Token URI ----");
        console.log(finalTokenUri);
        console.log("--------------------\n");
        _safeMint(msg.sender, newItemId);
        _setTokenURI(newItemId, finalTokenUri);
        console.log(
            "An NFT w/ ID %S has been minted to %S",
            newItemId,
            msg.sender
        );
        _tokenIds.increment();
        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
