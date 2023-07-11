// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.10;

import {IPekoIncentivesController} from '../../interfaces/IPekoIncentivesController.sol';

contract MockIncentivesController is IPekoIncentivesController {
  function handleAction(address, uint256, uint256) external override {}
}
