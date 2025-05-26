// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

// 存储在临时存储器中的数据在交易后被清除。

//确保EVM版本和VM设置为Cancun
//Storage 存储-数据存储在区块链上
//Memory 内存-函数调用后数据被清除
//Transient storage 瞬态存储-事务处理后数据被清除
interface ITest {
    function val() external view returns (uint256);
    function test() external;
}

contract Callback {
    uint256 public val;

    // 回调 ITest 中的 val() 函数
    fallback() external {
        val = ITest(msg.sender).val();
    }

    function test(address target) external {
        ITest(target).test();
    }
}

contract TestStorage {
    uint256 public val;

    function test() public {
        val = 123;
        bytes memory b = "";
        msg.sender.call(b);
    }
}

/*
定义了一个名为 TestTransientStorage 的合约。
该合约包含一个名为 SLOT 的常量，其值为 0。
该合约还包含两个函数：test() 和 val()。
test() 函数使用 tstore 指令将值 321 存储到 SLOT 位置。
val() 函数使用 tload 指令从 SLOT 位置读取值并将其返回。
*/
contract TestTransientStorage {
    bytes32 constant SLOT = 0;

    /*
    test() 是一个公共的函数，意味着可以从外部调用它。
    使用 assembly 块来执行汇编代码。
    汇编代码使用 tstore 指令将值 321 存储到 瞬态存储的 SLOT（槽位 0）中

    调用外部合约：创建一个空的字节数组 b，然后通过 msg.sender.call(b) 向调用者
    合约发送一个低级别调用，此调用可能会触发调用者合约的fallback或receive函数。


   assembly：在 Solidity 中，assembly关键字用于嵌入汇编代码。也被称作Yul汇编。
   借助内联汇编，开发者能直接操作 EVM 底层，实现更精细的控制和优化，达到一些高功能

   assembly {
        // 汇编代码
   }

    */
    function test() public {
        assembly {
            tstore(SLOT, 321)
        }
        bytes memory b = "";
        msg.sender.call(b);
    }

    /*
    val是一个公共的 view 函数，意味着不会修改合约的状态，仅读取数据，返回一个uint256的值 v

    使用 assembly 块来执行汇编代码。
    汇编代码使用 tload 指令从 瞬态存储的 SLOT（槽位 0）中读数据，并将其复制给返回变量 v
    tload 时 Cancun 升级引入的操作码，用于从 瞬态存储 中读取数据。
    */
    function val() public view returns (uint256 v) {
        assembly {
            v := tload(SLOT)
        }
    }
}

// 使用瞬态存储实现的重入锁
contract ReentrancyGuard {
    bool private locked;

    modifier lock() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    // 35313 gas
    function test() public lock {
        // Ignore call error
        bytes memory b = "";
        msg.sender.call(b);
    }
}

// 使用 assembly 减少 gas 消耗
contract ReentrancyGuardTransient {

    // 声明一个常量，用于存储锁的状态。SLOT 代表存储重入锁状态的槽位。
    bytes32 constant SLOT = 0;

    // 定义一个名为 lock 的修饰器，用于实现重入锁的功能。
    modifier lock() {
        assembly {
            // 运用内联汇编调用 tload 操作码，从瞬态存储的 SLOT 槽位中读取数据。
            // 如果读取到的数据不为 0，则使用 revert 操作码抛出异常，回滚交易。
            if tload(SLOT) { revert(0, 0) }
            // 若值为 0，则使用 tstore 操作码将 1 存储到瞬态存储的 SLOT 槽位中，
            // 把锁状态设为 1
            tstore(SLOT, 1)
        }
        _;
        assembly {
            // 运用内联汇编调用 tstore 操作码，将 0 存储到瞬态存储的 SLOT 槽位中，
            // 把锁状态设为 0， 重置为未锁定
            tstore(SLOT, 0)
        }
    }

    // 21887 gas
    function test() external lock {
        // Ignore call error
        bytes memory b = "";
        msg.sender.call(b);
    }
}
