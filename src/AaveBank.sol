// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPool} from "./InterfacePool.sol";

/// @title Decentralized Bank
/// @author Numa
/// @notice Decentralized Bank using AAVE protocol. It allows to deposit and withdraw $DAI,
/// also allows users to ask for $USDC loans.
/// @dev using AAVE protocol

contract AaveBank {
    error AaveBank__UserWithInsufficientFunds();
    error AaveBank__NotEnoughCollateral();
    error AaveBank__DebtOverpay();

    IPool aavePool;

    mapping(address => uint256) s_depositedAmount;
    mapping(address => uint256) s_borrowedAmount;

    IERC20 usdc;
    IERC20 dai;

    constructor(
        address _poolAddress,
        address _daiAddress,
        address _usdcAddress
    ) {
        usdc = IERC20(_usdcAddress);
        dai = IERC20(_daiAddress);
        aavePool = IPool(_poolAddress);
    }

    function depositDai(uint _amount) external {
        if (dai.balanceOf(msg.sender) < _amount) {
            revert AaveBank__UserWithInsufficientFunds();
        }

        s_depositedAmount[msg.sender] += _amount;

        /// @notice this requires a previous approval from the user
        dai.transferFrom(msg.sender, address(this), _amount);

        dai.approve(address(aavePool), _amount);
        aavePool.supply(address(dai), _amount, address(this), 0);
    }

    function withdrawDai(uint _amount) external {
        if (s_depositedAmount[msg.sender] < _amount) {
            revert AaveBank__NotEnoughCollateral();
        }

        s_depositedAmount[msg.sender] -= _amount;

        aavePool.withdraw(address(dai), _amount, msg.sender);
    }

    function borrowUsdc(uint _amount) external {
        if (s_depositedAmount[msg.sender] < _amount) {
            revert AaveBank__NotEnoughCollateral();
        }

        s_borrowedAmount[msg.sender] += _amount;

        aavePool.borrow(address(usdc), _amount, 2, 0, address(this));

        usdc.transfer(msg.sender, _amount);
    }

    function repayUsdc(uint _amount) external {
        if (s_borrowedAmount[msg.sender] < _amount) {
            revert AaveBank__DebtOverpay();
        }

        require(usdc.balanceOf(msg.sender) >= _amount, "Not enough DAI");

        s_borrowedAmount[msg.sender] -= _amount;

        /// @notice this requires a previous approval from the user
        usdc.transferFrom(msg.sender, address(this), _amount);

        usdc.approve(address(aavePool), _amount);
        aavePool.repay(address(usdc), _amount, 2, address(this));
    }
}
