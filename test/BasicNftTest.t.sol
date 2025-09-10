// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {Test} from "forge-std/Test.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {MintBasicNft} from "../script/Interactions.s.sol";

contract BasicNftTest is Script, Test {
    DeployBasicNft public deployer;
    BasicNft public basicNft;

    address public USER = makeAddr("user");
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function setUp() public {
        // Deploy the contract
        deployer = new DeployBasicNft();
        basicNft = deployer.run();
    }

    function testNameIsCorrect() public view {
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assert(keccak256(abi.encodePacked(expectedName)) == keccak256(abi.encodePacked(actualName)));
    }

    function testSymbolIsCorrect() public view {
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNft.symbol();
        assert(keccak256(abi.encodePacked(expectedSymbol)) == keccak256(abi.encodePacked(actualSymbol)));
    }

    function testCanMintandHasBalance() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        assert(basicNft.balanceOf(USER) == 1);

        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == keccak256(abi.encodePacked(PUG)));
    }

    function testReturnsTokenUri() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        string memory tokenUri = basicNft.tokenURI(0);
        assert(keccak256(abi.encodePacked(tokenUri)) == keccak256(abi.encodePacked(PUG)));
    }

    function testGetTokenCOunter() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        uint256 tokenCounter = basicNft.getTokenCounter();
        assert(tokenCounter == 1);
    }

    function testTokenUriRevertsIfAddressZero() public {
        vm.prank(USER);
        basicNft.mintNft(PUG);
        vm.expectRevert();
        basicNft.tokenURI(1);
    }

    function testTokenCounterIncreasesOnMint() public {
        uint256 startingTokenCounter = basicNft.getTokenCounter();
        vm.prank(USER);
        basicNft.mintNft(PUG);
        uint256 newTokenCounter = basicNft.getTokenCounter();
        assertEq(newTokenCounter, startingTokenCounter + 1);
    }

    function testTokenCounterStartsAtZero() public view {
        uint256 tokenCounter = basicNft.getTokenCounter();
        assertEq(tokenCounter, 0);
    }

    function testMintWithScript() public {
        uint256 startingTokenCount = basicNft.getTokenCounter();
        MintBasicNft mintBasicNft = new MintBasicNft();
        mintBasicNft.mintNftOnContract(address(basicNft));
        assert(basicNft.getTokenCounter() == startingTokenCount + 1);
    }
}
