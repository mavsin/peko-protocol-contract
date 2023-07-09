// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./types/DataTypes.sol";

/**
 * @title Helpers library
 * @author Peko
 */
library Helpers {
    /**
     * @notice Fetches the user current stable and variable debt balances
     * @param user The user address
     * @param reserveCache The reserve cache data object
     * @return The stable debt balance
     * @return The variable debt balance
     */
    function getUserCurrentDebt(
        address user,
        DataTypes.ReserveCache memory reserveCache
    ) internal view returns (uint256, uint256) {
        return (
            IERC20(reserveCache.stableDebtTokenAddress).balanceOf(user),
            IERC20(reserveCache.variableDebtTokenAddress).balanceOf(user)
        );
    }
}
