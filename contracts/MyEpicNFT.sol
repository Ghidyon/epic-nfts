// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import some OpenZeppelin Contracts
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

// inherit the contracts we've imported to access the contract's methods
contract MyEpicNFT is ERC721URIStorage {
    // magic given to us by OpenZeppelin to help us keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // this is our SVG code, all we need to change is the word that's displayed.
    // everything else stays the same
    // hence, we make a baseSvg variable here that all our NFTs can use.

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // Created three arrays, each with their own theme of random words.
    // Pick some random funny words
    string[] firstWords = [
        "Epic",
        "Terrible",
        "Caring",
        "Sad",
        "Mild",
        "Tender",
        "Amazing",
        "Genius",
        "Hilarious",
        "Excellent",
        "Intelligent",
        "Beaury"
    ];
    string[] secondWords = [
        "Beans",
        "Eba",
        "Yam",
        "Carrot",
        "Pineapple",
        "Kunu",
        "Ewedu",
        "Apple",
        "Cashew",
        "Orange",
        "Cucumber",
        "Udara"
    ];
    string[] thirdWords = [
        "Gorilla",
        "Monkey",
        "Chimpanzee",
        "Bear",
        "Snake",
        "Ant",
        "Elephant",
        "Tiger",
        "Ape",
        "Dog",
        "Cat",
        "Lion",
        "Tortoise"
    ];

    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // I seed the random generator
        uint256 rand = random(
            string(abi.encodePacked("epic", Strings.toString(tokenId)))
        );

        // squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % firstWords.length;

        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("beans", Strings.toString(tokenId)))
        );

        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("gorilla", Strings.toString(tokenId)))
        );

        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // we need to pass the name of our NFTs token and it's symbol
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT Contract. Whoa!");
    }

    // function user will hit to get their NFT
    function makeAnEpicNFT() public {
        // get the current tokenId, this starts at 0
        uint256 newItemId = _tokenIds.current();

        // we go and randomly grab on word from each of the three arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // we set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.","image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(
            string(
                abi.encodePacked(
                    "https://nftpreview.0xdev.codes/?code=",
                    finalTokenUri
                )
            )
        );
        console.log("--------------------\n");

        // actually mint the NFT to the user using msg.sender
        _safeMint(msg.sender, newItemId);

        // set the NFT's data
        _setTokenURI(newItemId, finalTokenUri);

        // see when the nft is minted and to who
        console.log(
            "An NFT with ID %s, has been minted to %s",
            newItemId,
            msg.sender
        );

        // increment the counter for when the next NFT is minted
        _tokenIds.increment();
    }
}
