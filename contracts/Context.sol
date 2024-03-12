// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;
contract Context{
    function _msgSender() internal view returns(address){
        return msg.sender;
    }
}