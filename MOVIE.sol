// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NuovoCinemaPurgatorio is ERC721, Ownable {
    using Strings for uint256;
    using Counters for Counters.Counter;

    uint256 public seats = 0;
    Counters.Counter private tickets;
    uint256 public price = 15;
    uint256 public onAir = 100000000000000;
    uint256 public open = false;
 
    constructor() ERC721("𝙤𝙙𝙜𝙚𝙡𝙤𝙣", "MOVIE") {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://______________________________________________";
    }

    function buyTicket() public payable {
        safeMint(msg.sender, tickets.current());
    }

    function safeMint(address to, uint256 tokenId) internal {
	require(open);
	require(seats < 25);
	require(onAir >= block.number + 10000);
	require(msg.value >= price);
	tickets.increment();
	seats +=1;
	if (seats == 25) {
            onAir = block.number;
	    seats = 0;
	}
        _safeMint(to, tokenId);
    }

    function manualMint(address to, uint256 tokenId) public onlyOwner {
        safeMint(to, tokenId);
    }

    function setOpen(bool _open) public onlyOwner {
        open = _open;
    }

    function setSeats(uint256 _seats) public onlyOwner {
        seats = _seats;
    }

    function withdraw() public onlyOwner {
        (bool os, ) = payable(owner()).call{value: address(this).balance}("");
        require(os);
  }
}
