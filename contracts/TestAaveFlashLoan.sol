//SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./interfaces/aave/FlashLoanReceiverBase.sol";

abstract contract TestAaveFlashLoan is FlashLoanReceiverBase {
    using SafeMath for uint;
    event Log (string message, uint value);
    constructor (ILendingPoolAddressesProvider _addressProvider)
        FlashLoanReceiverBase(_addressProvider)
    {}

    function testFlashLoan(address asset, uint amount) external {
        uint bal = IERC20(asset).balanceOf(address(this));
        require(bal>amount, "bal<=amount");

        address receiver = address(this);
        address[] memory assets = new address[] (1);
        assets[0] = asset;
        uint[] memory amounts = new uint[](1);
        uint[] memory modes = new uint[](1);
        amounts[0] = amount;
        modes[0]=0;

        //modes --> 0 = no debt, 1 = stable, 2 = variable
        // 0 -> pay everything that you have borrowed
        // onBehalfOf works when the address who receives the debt is different than
        // the person who is issuing the loan

        address onBehalfOf = address(this);
        //since the person who is issuing the loan is the same person paying of tthe debt 

        bytes memory params = "";
        //extra data can be passed via abu.encode(...)

        uint16 referralCode = 0;

        LENDING_POOL.flashLoan(
            receiver,
            assets,
            amounts,
            modes,
            onBehalfOf,
            params,
            referralCode
        );
    }

    function executeOperation(
        address[] calldata assets,
        uint[] calldata amounts,
        uint[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool){

        
        //the primary function for writing arbitrage, liquidation, defi exploits, etc
        //repay Aave
        uint _assetslen = assets.length;
        for (uint i = 0; i < _assetslen; i++ ){
            emit Log("borrowed", amounts[i]);
            emit Log("fee", premiums[i]);

            uint amountOwing = amounts[i].add(premiums[i]);
            IERC20(assets[i]).approve(address(LENDING_POOL), amountOwing);
        }
        return true;
    }
}