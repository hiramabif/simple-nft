// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract MintBasicNft is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("BasicNft", block.chainid);
        mintNftOnContract(mostRecentlyDeployed); // if i wanted to test to see if this still gets me the most recent deployment, even though i have changed ffi permission, how will i do it?
    }

    function mintNftOnContract(address contractAddress) public {
        require(contractAddress != address(0), "Contract address cannot be zero");
        _mintNftOnContract(contractAddress); // Call the private function to mint NFT
    }

    function _mintNftOnContract(address contractAddress) private {
        vm.startBroadcast(); // Start recording transactions for broadcasting
        BasicNft basicNft = BasicNft(contractAddress); // Cast the contract address to BasicNft type
        basicNft.mintNft(PUG); // Call mintNft function with PUG URI as parameter
        vm.stopBroadcast(); // Stop recording transactions
    }
}
