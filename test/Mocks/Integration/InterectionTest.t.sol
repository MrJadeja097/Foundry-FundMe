// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../../src/fundMe.sol";
import {deployFundMe} from "../../../script/deployFundMe.s.sol";
import {FundfundMe, withdrawfundMe} from "../../../script/Interactions.s.sol";

contract InterectionsTest is Test {
    FundMe fundme;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant GAS_PRICE = 1 ;
    

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployFundMe dfundme = new deployFundMe();
        fundme = dfundme.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    function testUsercanFundInterection() public {
        FundfundMe fundfundme = new FundfundMe();
        fundfundme.fundfundMe(address(fundme));

        withdrawfundMe withdrawfundme = new withdrawfundMe();
        withdrawfundme.WithdrawfundMe(address(fundme));

        assert(address(fundme).balance == 0);
    }
}