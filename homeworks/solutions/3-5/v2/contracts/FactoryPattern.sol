// SPDX-License-Identifier: MIT

// ·-----------------------|----------------------------|-------------|----------------------------·
// |  Solc version: 0.8.2  ·  Optimizer enabled: false  ·  Runs: 200  ·  Block limit: 6718946 gas  │
// ························|····························|·············|·····························
// |  Methods                                                                                      │
// ·············|··········|··············|·············|·············|··············|··············
// |  Contract  ·  Method  ·  Min         ·  Max        ·  Avg        ·  # calls     ·  eur (avg)  │
// ·············|··········|··············|·············|·············|··············|··············
// |  Deployments          ·                                          ·  % of limit  ·             │
// ························|··············|·············|·············|··············|··············
// |  Factory              ·           -  ·          -  ·    1977329  ·      29.4 %  ·          -  │
// ·-----------------------|--------------|-------------|-------------|--------------|-------------·

pragma solidity^0.8.0;

import "./Foundation.sol";
import "@openzeppelin/contracts/proxy/Clones.sol";

contract Factory {
    address public tokenImplemetation;
    address[] public implementations;
    
    constructor() payable {
       Foundation origin = new Foundation(); 
       tokenImplemetation = address(origin);
       Foundation(tokenImplemetation).initialize("primary","gg", block.timestamp + 33333); 
       implementations.push(tokenImplemetation);
    }

    function createClone(string memory _name, string memory _description, uint _time) public {
        address clone = Clones.clone(tokenImplemetation);
        Foundation(clone).initialize(_name, _description, block.timestamp + _time); 
        implementations.push(clone);
    }

    function getClone() public view returns (address[] memory) {
        return implementations;
    }

    function getCloneIndex(uint _index) public view returns (address) {
        return implementations[_index];
    }

}
