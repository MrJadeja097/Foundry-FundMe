// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/Mocks/MockV3Aggreagtor.sol";

contract HelperConfig is Script {
    
    struct NetworkConfig {
        address priceFeed; // ETH/USD price feed address
    }

    uint8 public constant DECIMAL = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetworkConfig = GetSepoliaEthConfig();
        } else if (block.chainid == 1) {
            activeNetworkConfig = GetMainnetEthConfig();
        } else {
            activeNetworkConfig = GetorCreateAnvilEthConfig();
        }
    }

    NetworkConfig public activeNetworkConfig;

    function GetSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        // Price feed address
        NetworkConfig memory sepoloaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return sepoloaConfig;
    }

    function GetMainnetEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory mainetConfig = NetworkConfig({
            priceFeed: 0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419
        });
        return mainetConfig;
    }

    function GetorCreateAnvilEthConfig() public returns (NetworkConfig memory) {
        // Price feed address
        if (activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        // MockV3Aggregator mokepricefeed = new MockV3Aggregator(8, 2000e8);
        MockV3Aggregator mokepricefeed = new MockV3Aggregator(
            DECIMAL,
            INITIAL_PRICE
        );
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mokepricefeed)
        });
        return anvilConfig;
    }
}
