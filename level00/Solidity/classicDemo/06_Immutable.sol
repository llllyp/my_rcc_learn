pragma solidity ^0.8;

contract Immutable {
    //Immutable variables  不可变变量
    //不可变变量就像常量。不可变变量的值可以在构造函数中设置，但之后不能修改。
    address public immutable MY_ADDRESS;

    uint public immutable MY_UINT;

    constructor(uint _myUint) {
        MY_ADDRESS = msg.sender;
        MY_UINT = _myUint;
    }

}