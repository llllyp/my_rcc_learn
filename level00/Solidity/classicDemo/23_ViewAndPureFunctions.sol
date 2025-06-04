// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
Getter函数可以声明为“view”或“pure”。

`View函数声明不会更改任何状态。

`Pure`函数声明不会更改或读取任何状态变量。
*/
contract ViewAndPureFunctions {

    uint256 public x = 1;

    // 承诺不修改状态。
    function addToX(uint256 y) public view returns (uint256) {
        return x + y;
    }

    // 承诺不修改或读取状态。
    function add(uint256 i, uint256 j) public pure returns (uint256) {
        return i + j;
    }

}