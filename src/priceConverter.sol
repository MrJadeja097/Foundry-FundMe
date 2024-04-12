// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function GetPrice (AggregatorV3Interface Pricefeed) internal view returns (uint256) {
        // AggregatorV3Interface pricefeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (,int256 price,,,) = Pricefeed.latestRoundData();

        // price of ETH in USD
        // 2000.00000000
        return uint(price * 1e10);

    }

    function GetConversionRate(uint256 ethAmount, AggregatorV3Interface Pricefeed) view public returns (uint256) {
        // 1 ETH = ?
        // 2000.000000000000000000
        uint256 ethPrice = GetPrice(Pricefeed);
        // ( 2000_000000000000000000 * 1_000000000000000000 ) / 1e18;
        // $2000 = 1 ETH
        uint256 ethAmountInUSD = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUSD;
    }

    function GetVersion () view internal returns (uint256) {
        // address 0x694AA1769357215DE4FAC081bf1f309aDC325306

        return AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306).version();
    }

}