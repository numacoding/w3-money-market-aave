// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {AaveBank} from "../src/AaveBank.sol";
import {DeployAaveBank} from "../script/DeployAaveBank.s.sol";

contract AaveBankTest {
    AaveBank aaveBank;

    uint256 constant INITIAL_FUNDS = 5 ether;
}
