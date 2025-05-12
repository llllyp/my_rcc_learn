// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract BBB {
    //实现一个函数，计算斐波那契数列的第 n 项（注意 gas 限制）
    function fibonacci(uint n) public pure returns (uint) {
        if (n == 0) {
            return 0;
        }
        if (n == 1) {
            return 1;
        }
        uint a = 0;
        uint b = 1;
        for (uint i = 2; i <= n; i++) {
            uint c = a + b;
            a = b;
            b = c;
        }
        return b;
    }
}
