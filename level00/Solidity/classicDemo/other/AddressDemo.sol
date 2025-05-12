// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// 练习，实现一个简单的存款和取款合约
contract AddressDemo {
    // balances 余额
    mapping(address => uint) public balances;

    // 存款
    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    // 提款
    function withdraw(uint256 amount) public {
        // 所取金额不能超过当前余额
        require(balances[msg.sender] >= amount, "Insufficient balance");
        // 余额减少
        balances[msg.sender] -= amount;
        // transfer 将以太坊转移到另一个地址
        payable(msg.sender).transfer(amount);
    }

    // 查看余额
    function checkBalance() public view returns(uint256) {
        return balances[msg.sender];
    }

}
