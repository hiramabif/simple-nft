// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {MoodNft} from "../src/MoodNft.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DeployMoodNft is Script {
    function run() external returns (MoodNft) {
        string memory _sad_svg = vm.readFile("./img/sad.svg");
        string memory _happy_svg = vm.readFile("./img/happy.svg");
        console.log("Sad SVG: ", _sad_svg);
        vm.startBroadcast();
        MoodNft moodNft = new MoodNft(
            svgToImageURI(_sad_svg),
            svgToImageURI(_happy_svg)
        );
        vm.stopBroadcast();
        console.log("MoodNft deployed to: ", address(moodNft));
        return moodNft;
    }

    function svgToImageURI(
        string memory svg
    ) public pure returns (string memory) {
        string memory baseURL = "data:image/svg+xml;base64,";
        string memory svgBase64Encoded = Base64.encode(
            bytes(string(abi.encodePacked(svg)))
        );
        return string.concat(baseURL, svgBase64Encoded);
        // return string(
        //     abi.encodePacked(baseURL, svgBase64Encoded)
        // ); Means same as ln18
    }
}
