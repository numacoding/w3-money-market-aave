// SPDX-License-Identifier: MIT

// Sepolia
// USDC Variable Debt Token: 0x36B5dE936eF1710E1d22EabE5231b28581a92ECc
// USDC Address: 0x2B0974b96511a728CA6342597471366D3444Aa2a
// DAI aToken: 0x29598b72eb5CeBd806C5dCD549490FdA35B13cD8
// DAI address: 0x82fb927676b53b6eE07904780c7be9b4B50dB80b
// Pool address: 0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951

// Mainnet
// Pool: 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2
// USDC: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
// DAI: 0x6B175474E89094C44Da98b954EedeAC495271d0F
// aDAI: 0x018008bfb33d285247A21d44E50697654f754e63
// debtUSDC: 0x72E95b8931767C79bA4EeE721354d6E99a61D004

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";

contract HelperConfig is Script {
    struct NetworkConfig {
        address poolAddress;
        address daiAddress;
        address usdcAddress;
    }

    NetworkConfig public activeNetworkConfig;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = getMainnetEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            poolAddress: 0x6Ae43d3271ff6888e7Fc43Fd7321a503ff738951,
            daiAddress: 0x82fb927676b53b6eE07904780c7be9b4B50dB80b,
            usdcAddress: 0x2B0974b96511a728CA6342597471366D3444Aa2a
        });

        return sepoliaConfig;
    }

    function getMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainnetConfig = NetworkConfig({
            poolAddress: 0x87870Bca3F3fD6335C3F4ce8392D69350B4fA4E2,
            daiAddress: 0x6B175474E89094C44Da98b954EedeAC495271d0F,
            usdcAddress: 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48
        });

        return mainnetConfig;
    }
}
