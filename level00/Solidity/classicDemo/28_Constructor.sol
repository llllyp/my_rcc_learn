// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract X {
    string public name;

    constructor(string memory _name) {
        name = _name;
    }

}

contract Y {
    string public text;

    constructor(string memory _text) {
        text = _text;
    }

}
//有两种方法可以使用参数初始化父合约。
//在继承列表中传递参数。
contract B is X("Input to X"), Y("Input to Y") {}

contract C is X, Y {
    //在构造函数中传递参数，
    //类似于函数修饰符。
    constructor(string memory _name, string memory _text) X(_name) Y(_text) {}
}
//父构造函数总是按照继承的顺序调用，而不管子合约构造函数中列出的父合约的顺序如何。

//调用构造函数的顺序：
// 1. X
// 2. Y
// 3. D
contract D is X, Y {
    constructor() X("X was called") Y("Y was called") {}
}

// 调用构造函数的顺序:
// 1. X
// 2. Y
// 3. E
contract E is X, Y {
    constructor() Y("Y was called") X("X was called") {}
}