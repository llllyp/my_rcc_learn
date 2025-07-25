智能合约 ABI（Application Binary Interface，应用程序二进制接口）是连接高级编程语言和区块链底层执行环境的桥梁，在智能合约交互中起着关键作用

在软件开发中，合约与合约之间的调用通常发生在区块链平台上，特别是在智能合约领域。智能合约是一种在区块链上执行的自动化合约，它们可以编程执行特定的功能，并且它们之间可以相互调用。

在以太坊这样的区块链平台上，智能合约之间的调用通常是通过合约地址和函数调用来实现的。以下是一种基本的合约调用方式：

1. 获取被调用合约的地址： 
    在调用合约中，你需要获取目标合约的地址。这通常通过在部署智能合约时获得目标合约的地址，或者通过其他途径（例如查看区块链浏览器）来获取。
2.  定义接口： 
    为了与目标合约进行交互，你需要在调用合约中定义一个接口，以便调用目标合约的函数。这个接口通常包括目标合约的函数签名和返回值类型。
3. 调用函数： 
    通过目标合约的地址和定义的接口，在调用合约中调用目标合约的函数。这可以通过调用合约的方法或者使用底层的调用指令来实现。
4. 处理返回值（可选）： 
    如果被调用的合约函数有返回值，调用合约可以选择处理这些返回值，以便根据需要执行后续操作。
假设我们有两个智能合约：合约 A 和合约 B。合约 A 想要调用合约 B 中的一个函数，并处理其返回值。

合约 B：
```solidity
// 合约B
pragma solidity ^0.8.0;
contract ContractB {
    uint256 public value;
    function setValue(uint256 _value) public {
        value = _value;
    }
    function getValue() public view returns (uint256) {
        return value;
    }
}
```

合约 A：
```solidity
// 合约A
pragma solidity ^0.8.0;
// 引入合约B的ABI
import "./ContractB.sol";
contract ContractA {
    ContractB public contractB; // 合约B实例
    constructor(address _contractBAddress) {
        contractB = ContractB(_contractBAddress); // 实例化合约B
    }
    // 向合约B设置值
    function setValueInContractB(uint256 _value) public {
        contractB.setValue(_value);
    }
    // 从合约B获取值
    function getValueFromContractB() public view returns (uint256) {
        return contractB.getValue();
    }
}
```