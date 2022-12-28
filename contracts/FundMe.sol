// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// chainlink yuklemeden compile yaparsanız hata vericektir
// "yarn add --dev @chainlink/contracts"

import "./PriceConverter.sol";

error FundMe_NotOwner();

contract FundMe {
    using PriceConverte for uint256;

    uint256 public constant MINIMUM_USD = 10 * 1e18;
    address[] private s_funders;

    mapping(address => uint256) private s_addressToAmountFunded;

    address private i_owner;
    
    AggregatorV3Interface private s_priceFeed;

    constructor(address s_priceFeedAdress) {
        i_owner = msg.sender;
        s_priceFeed = AggregatorV3Interface(s_priceFeedAdress);
    }

    function fund() public payable {
        
        require(
            msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD,
            "Did not send enough"
        );
        s_funders.push(msg.sender);
        s_addressToAmountFunded[msg.sender] += msg.value;
    }

    // bu withdrawın gas optimizasyonsuz hali aradaki farkı gormek istersen yorumdan çıkarıp gas islemlerine bakabilirsin
    // function withdraw() public onlyOwner {
    //     for (
    //         uint256 funderIndex = 0;
    //         funderIndex < s_funders.length;
    //         funderIndex++
    //     ) {
    //         address funder = s_funders[funderIndex];
    //         s_addressToAmountFunded[funder] = 0;
    //     }
    //     s_funders = new address[](0);

    //     (bool callSuccess, ) = payable(msg.sender).call{
    //         value: address(this).balance
    //     }("");
    //     require(callSuccess, "Call Failed");
    // }

    function cheaperWithdraw() public onlyOwner {
        address[] memory funders = s_funders;
        
        for (
            uint256 funderIndex = 0;
            funderIndex < funders.length;
            funderIndex++
        ) {
            address funder = funders[funderIndex];
            s_addressToAmountFunded[funder] = 0;
        }
        s_funders = new address[](0);
        // payable(msg.sender).transfer(address(this).balance);
        (bool success, ) = i_owner.call{value: address(this).balance}("");
        require(success);
    }

    modifier onlyOwner() {
        if (msg.sender != i_owner) revert FundMe_NotOwner();
        _;
    }

    receive() external payable {
        fund();
    }

    fallback() external payable {
        fund();
    }

    function getAddressToAmountFunded(
        address fundingAddress
    ) public view returns (uint256) {
        return s_addressToAmountFunded[fundingAddress];
    }

    function getVersion() public view returns (uint256) {
        return s_priceFeed.version();
    }

    function getFunder(uint256 index) public view returns (address) {
        return s_funders[index];
    }

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getPriceFeed() public view returns (AggregatorV3Interface) {
        return s_priceFeed;
    }
}
