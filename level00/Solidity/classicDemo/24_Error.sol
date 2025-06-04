// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
错误将撤消在事务期间对状态所做的所有更改。

你可以通过调用`require`、`reverse`或`assert`来抛出错误。

-“require”用于在执行之前验证输入和条件。
-“reverse”类似于“require”。有关详细信息，请参阅下面的代码。
-`assert`用于检查不应为false的代码。断言失败可能意味着存在错误。

使用自定义错误来节省gas。

*/
contract Error {

    function testRequire(uint256 _i) public pure {
        //应使用Require来验证以下条件：
        //-输入
        //-执行前的条件
        //-调用其他函数时返回值
        require(_i > 10, "Input must be greater than 10");
    }

    function testRevert(uint256 _i) public pure {
        //当要检查的条件复杂时，Revert非常有用。
        //这段代码的作用与上面的示例完全相同
        if (_i <= 10) {
            revert("Input must be greater than 10");
        }
    }

    uint256 public num;

    function testAssert() public view {
        //断言只应用于测试内部错误，
        //并检查不变量。

        //这里我们断言num总是等于0
        //因为无法更新num的值
        assert(num == 0);
    }

    //自定义错误
    error myError(uint256 balance, uint256 withdrawAmount);

    function testCustomError(uint256 _withdrawAmount) public view {
        uint256 bal = address(this).balance;
        if (bal < _withdrawAmount) {
            revert myError({
                balance: bal,
                withdrawAmount: _withdrawAmount
            });
        }
    }

}