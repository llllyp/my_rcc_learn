// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Event {
    //事件声明
    //最多可以索引3个参数。
    //索引参数可帮助您根据索引参数过滤日志
    event Log(address indexed sender, string message);
    event AnotherLog();

    function test() public {
        emit Log(msg.sender, "Hello World!");
        emit Log(msg.sender, "Hello EVM!");
        emit AnotherLog();
    }
}