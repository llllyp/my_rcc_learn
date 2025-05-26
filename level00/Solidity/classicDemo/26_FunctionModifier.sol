// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract FunctionModifier {

    address public owner;
    uint256 public x = 10;
    bool public locked;

    constructor() {
        // 将交易发送方设置为合同的所有者。
        owner = msg.sender;
    }

    //modifier，用于检查调用者是否是合约所有者
    modifier onlyOwner() {
        // 如果调用者不是合同的所有者，则中止执行。
        require(msg.sender == owner, "Not owner");
        //下划线是一个仅在内部使用的特殊字符
        //一个函数修饰符，它告诉Solidity执行其余代码。
        _;
    }

    //modifier可以接受输入。此修改器检查传入的地址不是零地址。
    modifier validAddress(address _addr) {
        require(_addr != address(0), "Not valid address");
        _;
    }

    function changeOwner(address _newOwner)
        public
        onlyOwner
        validAddress(_newOwner)
    {
        owner = _newOwner;
    }

    // modifier 实现重入锁
    modifier noReentrancy() {
        require(!locked, "No reentrancy");

        locked = true;
        _;
        locked = false;
    }

    function decrement(uint256 i) public noReentrancy {
        x -= i;

        if (i > 1) {
            decrement(i - 1);
        }
    }

}