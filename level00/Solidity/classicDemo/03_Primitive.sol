// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

contract Primitive {

    bool public boo = true;

    /*
     uint8      ranges from 0 to 2 ** 8 - 1 = 255
     uint16     ranges from 0 to 2 ** 16 - 1 = 65535
     uint32     ranges from 0 to 2 ** 32 - 1 = 4294967295
     ······
     uint256    ranges from 0 to 2 ** 256 - 1
    */

    uint8 public number_8 = 1;

    uint256 public number_256 = 456;

    // uint 默认为 uint256
    uint public number_256_2 = 123;

    /*
    int 包含正负数以及 0，uint 只包含非负数
    */
    int8 public i8 = -1;

    int256 public i256 = 123;

    int256 public i = -123;

    // minimum and maximum of int
    int256 public minInt = type(int256).min;
    int256 public maxInt = type(int256).max;

    address public addr = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    /*
    在Solidity中，数据类型字节表示字节序列。
    Solidity提供两种字节类型：
        -固定大小的字节数组
        -动态大小的字节数组。

    Solidity中的术语bytes表示字节的动态数组。
    这是byte[]的简写。
    */

    bytes1 a = 0xb5; // [10110101]
    bytes1 b = 0x56; // [01010110]

    // 默认值
    bool public defaultBool; //false
    uint256 public defaultUint; // 0
    int256 public defaultInt; // 0
    address public defaultAddress; // 0x0000000000000000000000000000000000000000

}