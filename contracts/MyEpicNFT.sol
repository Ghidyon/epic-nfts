// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

// import some OpenZeppelin Contracts
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// inherit the contracts we've imported to access the contract's methods
contract MyEpicNFT is ERC721URIStorage {
    // magic given to us by OpenZeppelin to help us keep track of tokenIds
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // we need to pass the name of our NFTs token and it's symbol
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT Contract. Whoa!");
    }

    // function user will hit to get their NFT
    function makeAnEpicNFT() public {
        // get the current tokenId, this starts at 0
        uint256 newItemId = _tokenIds.current();

        // actually mint the NFT to the user using msg.sender
        _safeMint(msg.sender, newItemId);

        // set the NFT's data
        _setTokenURI(newItemId, "https://jsonkeeper.com/b/O6YX");

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
