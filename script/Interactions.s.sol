// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/fundMe.sol";

contract FundfundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function fundfundMe (address MostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(MostRecentlyDeployed)).Fundme{value: SEND_VALUE}();
        vm.stopBroadcast();
        console.log("Funded FundMe with %s", SEND_VALUE);
    }

    function run() external {

        address MostRecentlyDelpoyed = DevOpsTools.get_most_recent_deployment("FundME", block.chainid);
        vm.startBroadcast();
        fundfundMe(MostRecentlyDelpoyed);
        vm.stopBroadcast();

    }
}

contract withdrawfundMe is Script { 

    function WithdrawfundMe (address MostRecentlyDeployed) public {
        vm.startBroadcast();
        FundMe(payable(MostRecentlyDeployed)).Withraw();
        vm.stopBroadcast();
    }

    function run() external {

        address MostRecentlyDelpoyed = DevOpsTools.get_most_recent_deployment("FundME", block.chainid);
        vm.startBroadcast();
        WithdrawfundMe(MostRecentlyDelpoyed);
        vm.stopBroadcast();

    }
}