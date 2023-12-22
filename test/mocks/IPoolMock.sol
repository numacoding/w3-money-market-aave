// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;
import {IPool} from "../../src/InterfacePool.sol";

contract MockIPool is IPool {
    event SupplyCalled(
        address _asset,
        uint256 _amount,
        address _onBehalfOf,
        uint16 _referralCode
    );
    event WithdrawCalled(address _asset, uint256 _amount, address _to);
    event BorrowCalled(
        address _asset,
        uint256 _amount,
        uint256 _interestRateMode,
        uint16 _referralCode,
        address _onBehalfOf
    );
    event RepayCalled(
        address _asset,
        uint256 _amount,
        uint256 _rateMode,
        address _onBehalfOf
    );

    function supply(
        address _asset,
        uint256 _amount,
        address _onBehalfOf,
        uint16 _referralCode
    ) external override {
        emit SupplyCalled(_asset, _amount, _onBehalfOf, _referralCode);
    }

    function withdraw(
        address _asset,
        uint256 _amount,
        address _to
    ) external override returns (uint256) {
        emit WithdrawCalled(_asset, _amount, _to);
        return 0;
    }

    function borrow(
        address _asset,
        uint256 _amount,
        uint256 _interestRateMode,
        uint16 _referralCode,
        address _onBehalfOf
    ) external override {
        emit BorrowCalled(
            _asset,
            _amount,
            _interestRateMode,
            _referralCode,
            _onBehalfOf
        );
    }

    function repay(
        address _asset,
        uint256 _amount,
        uint256 _rateMode,
        address _onBehalfOf
    ) external override returns (uint256) {
        emit RepayCalled(_asset, _amount, _rateMode, _onBehalfOf);
        return 0;
    }
}
