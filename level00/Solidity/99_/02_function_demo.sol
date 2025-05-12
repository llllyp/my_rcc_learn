pragma solidity ^0.8;

contract FunctionDemo {

    uint public count = 1;

    //public 可见性，公共的，所有的都可见
    //pure 状态可变性修饰符，
    /*
            读取      写入
    pure    false    false
    view    true     false
    default true     true


    */
    function pureDemo(uint a, uint b) public pure  returns(uint) {
        // 修饰符为 pure ，无法读取 count，无法修改 count
        return a + b;
    }


    function getCount() view public  returns(uint) {
        // 修饰符为 view ，可以读取 count，不能修改 count
        return count;
    }

    function addCount(int a) public returns(uint) {
        // 修饰符为 default ，可以读取, 也可以修改
        return count += a;
    }


    // paylable  修饰符，可以接受 ETH
    function payableDemo() payable public {
        // 修饰符为 payable ，可以接受 ETH
    }

}