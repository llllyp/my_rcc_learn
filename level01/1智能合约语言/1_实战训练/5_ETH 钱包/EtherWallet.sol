// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
加深取钱方法的使用
- 任何人都可以发送金额到合约
- 只有 owner 可以取款
- 3 种取钱方式
*/
contract EtherWallet {
    address payable immutable public owner;
    // 日志记录事件
    event Log(string funName, address from, uint256 value, bytes data)

    constructor() {
        owner = payable(msg.sender);
    }

    receive() external payable {
        emit Log("receive", msg.sender, msg.value, "");
    }

    // 三种取钱方式 transfer send call
    function withdrwa1() external {
        require(msg.sender == owner, "not owner");
        // owner.transfer 相比 msg.sender 更消耗Gas
        // owner.transfer(address(this).balance);
        payable(msg.sender).transfer(100);
        emit Log("withdrwa1", msg.sender, address(this).balance, "");
    }

    function withdrwa2() external {
        require(msg.sender == owner, "Not owner");
        bool success = payable(msg.sender).send(200);
        require(success, "Send Failed");
    }

    function withdrwa3() external {
        require(msg.sender == owner, "Not owner");
        (bool success, ) = msg.sender.call{value: address(this).balance}("");
        require(success, "Call Failed");
    }

    // 查询余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }
}
