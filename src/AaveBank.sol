// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IPool} from "./InterfacePool.sol";

/// @title Decentralized Bank
/// @author Numa
/// @notice Decentralized Bank using AAVE protocol. It allows to deposit and withdraw $DAI,
/// also allows users to ask for $USDC loans
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

    function depositDai(uint amount) external {
        if (dai.balanceOf(msg.sender) < amount) {
            revert AaveBank__UserWithInsufficientFunds();
        }

        s_depositedAmount[msg.sender] += amount;

        //@audit-issue ver si acá tengo que hacer un transferFrom o si la función supply() lo hace por mi
        dai.transferFrom(msg.sender, address(this), amount);

        dai.approve(address(aavePool), amount);
        aavePool.supply(address(dai), amount, address(this), 0);
    }

    function withdrawDai(uint amount) external {
        if (s_depositedAmount[msg.sender] < amount) {
            revert AaveBank__NotEnoughCollateral();
        }

        s_depositedAmount[msg.sender] -= amount;

        aavePool.withdraw(address(dai), amount, msg.sender);
    }

    function borrowUsdc(uint amount) external {
        if (s_depositedAmount[msg.sender] < amount) {
            revert AaveBank__NotEnoughCollateral();
        }

        s_borrowedAmount[msg.sender] += amount;

        aavePool.borrow(address(usdc), amount, 2, 0, address(this));

        usdc.transfer(msg.sender, amount);
    }

    // @audit-issue Ver cómo hacer esta transferencia
    function repayUsdc(uint amount) external {
        if (s_borrowedAmount[msg.sender] < amount) {
            revert AaveBank__DebtOverpay();
        }

        require(usdc.balanceOf(msg.sender) >= amount, "Not enough DAI");

        s_borrowedAmount[msg.sender] -= amount;

        //usdc.approve(address(this), amount);
        usdc.transferFrom(msg.sender, address(this), amount);

        usdc.approve(address(aavePool), amount);
        aavePool.repay(address(usdc), amount, 2, address(this));
    }
}
