// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {AaveBank} from "../src/AaveBank.sol";
import {HelperConfig} from "./HelperConfig.s.sol";

contract DeployAaveBank is Script {
    function run() external returns (AaveBank, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig();
        (
            address poolAddress,
            address daiAddress,
            address usdcAddress
        ) = helperConfig.activeNetworkConfig();

        vm.startBroadcast();
        AaveBank aaveBank = new AaveBank(poolAddress, daiAddress, usdcAddress);
        vm.stopBroadcast();

        return (aaveBank, helperConfig);
    }
}
