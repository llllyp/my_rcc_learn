// SPDX-License-Identifier: MIT
pragma solidity ^0.8;
/*
所有人都可以存钱
    ETH
只有合约 owner 才可以取钱
只要取钱，合约就销毁掉 selfdestruct
扩展：支持主币以外的资产
    ERC20
    ERC721
*/

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract PiggyBank is ERC20, ERC721 {

    // 状态变量  immutable 关键字用于声明只能在构造函数中初始化一次的不可变状态变量
    address public immutable owner;

    // 事件
    event Deposit(address _ads, uint256 amount);
    event Withdraw(uint256 amount);

    // receive
    // receive函数是一个特殊的函数,用于接收ETH转账
    // external表示只能从外部调用
    // payable表示这个函数可以接收ETH
    receive() external payable {
        // 当收到ETH转账时,触发Deposit事件
        // msg.sender是转账人的地址
        // msg.value是转账的ETH数量
        emit Deposit(msg.sender, msg.value);
    }

    constructor() payable {
        owner = msg.sender;
    }

    // 取钱方法
    function withdraw() external {
        require(msg.sender == owner, "Not owner");
        emit Withdraw(address(this.balance));
        selfdestruct(payable(owner));
    }

    function getBalance() external view returns(uint256) {
        return address(this).balance;
    }


}