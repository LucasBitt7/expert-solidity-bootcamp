// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "hardhat/console.sol";

contract DogCoin is ERC20 {
    
    mapping(address => uint256) private _balances;
    
    uint256 private _totalSupply;
    address[] public holders;
    
    
    event User_Removed(address user);
    event User_Added(address user);


    constructor() ERC20("DogCoin", "DC") {
    }

    uint balance = balanceOf(msg.sender);
    function addHolder(address user) private {
        require(user != address(0));
        require(balance => 0);
        holders.push(user);
        _balances[user] = 0;
        emit User_Added(user);
    }

    function removeHolder(address user) private {
        require(user != address(0));
        for (uint i = 0; i < holders.length; i++) {
            if (holders[i] == user) {
                holders.pop();
                _balances[user] = 0;
                emit User_Removed(user);
                return;
            }
        }
    }

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
        
    }
}