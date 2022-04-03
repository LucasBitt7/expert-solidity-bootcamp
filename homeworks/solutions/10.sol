// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract YULViewFunction {

    // return msg.value
    function getValue() public payable returns(uint) {
        assembly {
            let msgvalue := callvalue()
            mstore(0x0, msgvalue)
            return(0x0, 32)
        }
    }
    
    function normalGetValue() public payable returns(uint) {
        return msg.value;
    }
}