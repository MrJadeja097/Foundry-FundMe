// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {PriceConverter} from "./priceConverter.sol";

error NotOwner();

contract FundMe{
    using PriceConverter for uint256;

    // uint256 public myvalue = 1;
    
    uint public constant minUSD = 5 * 10 ** 18 ; //5e18

    address private immutable owner;
    AggregatorV3Interface private spricef;

    constructor(address pricefeed) {
        owner = msg.sender;
        spricef = AggregatorV3Interface(pricefeed);
    }
    
    mapping (address  => uint256  ) private addressToAmountFunded;
    address[] private funders;

    function Fundme() public payable {

        // myvalue = myvalue + 2;
        // require(GetConversionRate(msg.value) >= minUSD, "Didn't sent Enough ETH"); // 1e18 == 1 ETH == 10*18 Wei
        require(msg.value.GetConversionRate(spricef) >= minUSD, "Didn't sent Enough ETH"); // 1e18 == 1 ETH == 10*18 Wei

        addressToAmountFunded[msg.sender] = addressToAmountFunded[msg.sender] + msg.value;
        funders.push(msg.sender);
    }
    
    modifier onlyOwner {
        // require ( msg.sender == owner, "Sender is not the Owner.");
        if (msg.sender != owner ) revert NotOwner();
        _;
    }

    function getVersion() public view returns (uint256){
        // AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        return spricef.version();
    }

    function Withraw() public onlyOwner {
        

        for (uint256 funderIndex=0; funderIndex < funders.length; funderIndex++){
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        funders = new address[](0);

        // // transfer
        // payable (msg.sender).transfer(address(this).balance);

        // //send
        // bool sendSuccess = payable (msg.sender).send(address(this).balance);
        // require ( sendSuccess, "Send Failed.");

        // call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Call failed");

    }


    // What happens when someone send ETH without calling Fund function
    // Explainer from: https://solidity-by-example.org/fallback/
    // Ether is sent to contract
    //      is msg.data empty?
    //          /   \ 
    //         yes  no
    //         /     \
    //    receive()?  fallback() 
    //     /   \ 
    //   yes   no
    //  /        \
    //receive()  fallback()

    
    // receive() external payable {
    //     Fundme();    
    // }

    // fallback() external payable {
    //     Fundme();
    // }

    // function showsender() public view returns (address) {
    //         return msg.sender;
    // }
    
    function getAddresstoAmountFunded (address fundingAddress) external view returns (uint256) {
        return addressToAmountFunded[fundingAddress];
    }

    function getFunder (uint256 index) external view returns (address) {
        return funders[index];
    }

    function getOwner () external view returns (address) {
        return owner;
    }
}