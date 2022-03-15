//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import "hardhat/console.sol";

contract DogCoin is Initializable, ERC20Upgradeable, UUPSUpgradeable, OwnableUpgradeable {
    address[] public holders;
    uint version;
    event newHolder(address);
    event deletedHolder(address);

    function initialize() public initializer {
        __ERC20_init_unchained("DogCoin", "DOG");
        version = 1; // TODO how to increment this number on an upgrade
    }

    // TODO add access control to this function
    function _authorizeUpgrade(address newImplementation) internal override {}

    function _afterTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        _addHolderIfNotExists(to);
        _deleteHolderIfBalanceZero(from);
    }

    function _addHolderIfNotExists(address account) internal {
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == account) {
                return;
            }
        }
        holders.push(account);
        emit newHolder(account);
    }

    function _deleteHolderIfBalanceZero(address account) internal {
        if (balanceOf(account) != 0) {
            return;
        }

        // swap and pop
        for (uint256 i = 0; i < holders.length; i++) {
            if (holders[i] == account) {
                holders[i] = holders[holders.length - 1];
                holders.pop();
                return;
            }
        }
        emit deletedHolder(account);
    }
}