// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/*
有几种方法可以从函数返回输出。

公共函数不能接受某些数据类型作为输入或输出
*/

contract Function {
    //函数可以返回多个值。
    function returnMany() public pure returns(uint256, bool, uint256) {
        return (1, true, 2);
    }

    /*
    返回的值可以命名。
    这允许您为每个返回值指定一个名称。
    这对于返回多个值的函数非常有用。
    这也允许您在函数中使用更具描述性的名称。
    */
    function named() public pure returns(uint256 x, bool y, uint256 z) {
        x = 1;
        y = true;
        z = 2;
        return (x, y, z);
    }

    //调用另一个时使用解构赋值
    //返回多个值的函数。
    function destructuringAssignments() public pure returns(
        uint256, bool, uint256, uint256, uint256
    ) {
        (uint256 i, bool b, uint256 j) = returnMany();

        // Values can be left out.
        // 定义了连个新的无符号变量x,y。两个逗号之间没有变量名，意味着忽略元素中的第二个值
        (uint256 x,, uint256 y) = (4, 5, 6);

        return (i, b, j, x, y);
    }

    // 不能将映射用于输入或输出

    // Can use array for input
    function arrayInput(uint256[] memory _arr) public {}

    // Can use array for output
    uint256[] public arr;

    function arrayOutput() public view returns (uint256[] memory) {
        return arr;
    }
}

// 带键值输入的调用函数
contract XYZ {
    function someFuncWithManyInputs(
        uint256 x,
        uint256 y,
        uint256 z,
        address a,
        bool b,
        string memory c
    ) public pure returns (uint256) {
        return x + y + z;
    }

    function callFunc() external pure returns (uint256) {
        return someFuncWithManyInputs(1, 2, 3, address(0), true, "c");
    }

    function callFuncWithKeyValue() external pure returns (uint256) {
        return someFuncWithManyInputs({
            a: address(0),
            b: true,
            c: "c",
            x: 1,
            y: 2,
            z: 3
        });
    }

}