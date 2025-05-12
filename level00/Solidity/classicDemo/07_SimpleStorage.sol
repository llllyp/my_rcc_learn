// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;


/*
    要写入或更新状态变量，需要发送一个事务。
    另一方面，可以免费读取状态变量，无需任何交易费用。
*/
contract SimpleStorage {

    uint256 public num;

    //发送一个事务来写入状态变量。
    function set(uint256 _num) public {
        num = _num;
    }

    //发送事务的情况下从状态变量读取
    function get() public view returns (uint256) {
        return num;
    }
}
