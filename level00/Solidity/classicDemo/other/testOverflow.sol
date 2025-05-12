// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

contract testOverflow {

    function add() public pure returns (uint8) {
        int8 a = 128;
        int8 b = a * 2;
        return b; //0
    }

    function add2() public pure returns (uint8){
        uint8 x = 240;
        uint8 y = 16;
        uint8 z = x + y;
        return z;//0
    }

    function sub() public pure returns (uint8){
        uint8 m = 1;
        uint8 n = m - 2;
        return n; //255

    }
}
