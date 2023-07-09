// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts/proxy/Proxy.sol";
import "./InitializableUpgradeabilityProxy.sol";
import "./BaseImmutableAdminUpgradeabilityProxy.sol";

/**
 * @title InitializableAdminUpgradeabilityProxy
 * @author Peko
 * @dev Extends BaseAdminUpgradeabilityProxy with an initializer function
 */
contract InitializableImmutableAdminUpgradeabilityProxy is
    BaseImmutableAdminUpgradeabilityProxy,
    InitializableUpgradeabilityProxy
{
    /**
     * @dev Constructor.
     * @param admin The address of the admin
     */
    constructor(address admin) BaseImmutableAdminUpgradeabilityProxy(admin) {
        // Intentionally left blank
    }
}
