// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import {Mapping} from "./12_Mapping.sol";

/*
数据位置-存储、内存和呼叫数据

变量被声明为“storage存储”、“memory内存”或“calldata调用数据”，以明确指定数据的位置。

-`storage`变量是一个状态变量（存储在区块链上）
-`memory`变量在内存中，并且在调用函数时存在
-`calldata`包含函数参数的特殊数据位置

*/
contract DataLocations {

    uint256[] public arr;
    mapping(uint256 => uint256) public myMap;

    struct MyStruct {
        uint256 a;
    }

    mapping(uint256 => MyStruct) myStructs;

    function f() {
        // 调用 _f 传递状态变量
        _f(arr, map, myStructs[1]);

        // 从映射中获取结构体
        MyStruct storage myStruct = myStructs[1];
        // 创建一个内存中的结构体
        MyStruct memory myMemStruct = MyStruct(0);
    }

    function _f(
        uint256[] storage _arr,
        mapping(uint256 => uint256) storage _myMap,
        Mystruct storage _myStruct
    ) internal {
        // do something with storage variables
    }

    // You can return memory variables
    function g(uint256[] memory _arr) public returns (uint256[] memory) {
        // do something with memory array
    }

    function h(uint256[] calldata _arr) external {
        // do something with calldata array
    }

}