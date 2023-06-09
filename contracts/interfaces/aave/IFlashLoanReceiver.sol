// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.7;

import {ILendingPoolAddressesProvider} from "../aave/ILendingPoolAddressesProvider.sol";
import {ILendingPool} from "../aave/ILendingPool.sol";

interface IFlashLoanReceiver {
    function executeOperation (
        uint256[]   calldata  amounts,
        address[]   calldata  assets,
        uint256[]   calldata  premiums,
        address     initiator,
        bytes       calldata  params
    ) external returns (bool);

    function ADDRESSES_PROVIDER() external view returns (ILendingPoolAddressesProvider);

    function LENDING_POOL() external view returns (ILendingPool);
}

