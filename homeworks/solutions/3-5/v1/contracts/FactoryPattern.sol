// // SPDX-License-Identifier: MIT
// pragma solidity^0.8.0;

// import "./Foundation.sol";

// contract Factory {
//     // The Factory contract is a simple contract that allows us to create some instances of one smart contract
//     // and store them in a list. On below line, we create a list of addresses, which will be used to store
//     Foundation[] private _foundation;
//     function createInstance(string memory name) public {
//         _foundation.push(new Foundation(name));
//     }
//     function getInstance(uint index) public view returns (address) {
//         return address(_foundation[index]);
//     }
//     function allFoundations() public view returns (Foundation[] memory coll) {
//         return coll;
//     }
// }

// //////////////////////LEGACY WAY////////////////////////// 2X MORE GWEI ///////// GO TO CloneFactoryPattern.sol
