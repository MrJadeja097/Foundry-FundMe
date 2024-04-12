// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../../src/fundMe.sol";
import {deployFundMe} from "../../../script/deployFundMe.s.sol";

contract fundMeTest is Test {

    FundMe fundme;

    address USER = makeAddr("user");
    uint256 constant SEND_VALUE = 0.1 ether;

    function setUp() external {
        // fundme = new FundMe(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        deployFundMe dfundme = new deployFundMe();
        fundme = dfundme.run();
        vm.deal(USER, 10 ether);
    }

    function testUSDfive() public {
        assertEq(fundme.minUSD(), 5e18);
    }

    function testOwnerisSender() public {
        // console.log(fundme.owner());
        // console.log(msg.sender);
        // us -> fundMeTest -> fundme
        // us -> fundMe (❌)   |   fundMeTest -> fundme (✅)
        // assertEq(fundme.owner(),msg.sender); // not matching
        assertEq(fundme.getOwner(),msg.sender);
    }

    function testPriceFeedVersionisAccurate() public {
        uint256 version = fundme.getVersion();
        assertEq(version, 4);
    }

    function testFundsFailsWithoutEnoughtEth() public {
        vm.expectRevert();

        fundme.Fundme(); // send 0 ETh
    }

    function testFundUpdatesFundedDataStructure() public {
        vm.prank(USER);
        fundme.Fundme{value: SEND_VALUE}();

        uint256 AmountFunded = fundme.getAddresstoAmountFunded(USER);
        assertEq(AmountFunded, SEND_VALUE);
    }

    function testAddsFundertoArrayofFunders() public {
        vm.prank(USER);
        fundme.Fundme{value: SEND_VALUE}();

        address funder = fundme.getFunder(0);
        assertEq(funder, USER);
    }

    modifier funded {
        vm.prank(USER);
        fundme.Fundme{value: SEND_VALUE}();
        _;
    }

    function testOnlyOwnercanWithraw() public funded {
        // vm.prank(USER);
        vm.expectRevert();
        fundme.Withraw();
    }

    function testWithdrawWithSingleOwner() public funded {
        // Arrange
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        // Act
        vm.prank(fundme.getOwner());
        fundme.Withraw();

        // Assert
        uint256 endingOwnerBalance = fundme.getOwner().balance;
        uint256 endingFundmeBalance = address(fundme).balance;

        assertEq(endingFundmeBalance, 0);
        assertEq(endingOwnerBalance, startingFundmeBalance + startingOwnerBalance);
    }

    function testWithdrawWithMultipleFunders() public funded {
        // Arrange
        uint160 numberOfFunders = 10;
        uint160 startingFunderIndex = 1;

        for (uint160 i = startingFunderIndex; i < numberOfFunders; i++ ) {
            
            hoax(address(i), 10 ether);
            fundme.Fundme{value: SEND_VALUE}();    
        }
        uint256 startingOwnerBalance = fundme.getOwner().balance;
        uint256 startingFundmeBalance = address(fundme).balance;

        // Act
        vm.startPrank(fundme.getOwner());
        fundme.Withraw();
        vm.stopPrank();

        // Assert
        assert(address(fundme).balance == 0);
        assert(fundme.getOwner().balance == startingOwnerBalance + startingFundmeBalance);

    }
}