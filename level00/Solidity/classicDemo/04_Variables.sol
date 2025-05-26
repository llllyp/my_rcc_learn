// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

//变量
contract Variables {

    string  public text = "Hello";
    uint256 public num = 123;

    function doSomething() public {
        // 本地变量
        uint256 i = 456;

        // 全局变量
        uint256 timestamp = block.timestamp; // block 全局变量

        address sender = msg.sender; // msg 全局变量
    }

}
