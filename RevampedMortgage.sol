// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;
pragma abicoder v2;

import "../node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "../node_modules/@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract MortgagePayment is Ownable, ReentrancyGuard {
    
    //Variables

    event Deposited(address indexed buyer, uint256 amount);
    event Withdrawn(address indexed seller, uint256 amount);
    
    uint public price;
    
    address payable public buyer;
    address payable public seller;
    
    //Mapping
    
    mapping(address => uint) public balance;
    
    //Functions
    
    function deposit() onlyOwner public payable returns(uint256) {
        price = msg.value;
        balance[msg.sender] += price;
        emit Deposited(msg.sender, price);
        return balance[msg.sender];
    }
    //transfer funds to seller - loaner
    
    function withdraw() onlyOwner public returns(uint) {
        
        seller.transfer(price); //sending mortgage price to the seller of the residence.
        
        emit Withdrawn(seller, price);

        return balance[msg.sender];
    }
   
}
