//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DogCoin is ERC20 {
    constructor() ERC20("DogCoin", "DC") {}

    address[] public holders;

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        _addHolder();
        _removeHolder();
    }

    function _addHolder() internal {
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == msg.sender) {
                return;
            }
        }
        holders.push(msg.sender);
    }

    function _removeHolder() internal {
        if (balanceOf(msg.sender) != 0) {
            return;
        }
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == msg.sender) {
                holders[i] = holders[holders.length - 1];
                holders.pop();
                return;
            }
        }
    }

    function mint(uint amount) public {
        _mint(msg.sender, amount);
    }
}