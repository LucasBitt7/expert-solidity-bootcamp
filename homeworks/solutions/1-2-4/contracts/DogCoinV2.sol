//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./DogCoin.sol";

contract DogCoinV2 is DogCoin {
    function updateVersion() public {
        version = 2;
    }
}