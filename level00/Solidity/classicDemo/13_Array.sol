pragma solidity ^0.8.0;

contract Array {

    uint256[] public arr1;
    uint256[] public arr2 = [1, 2, 3];

    uint256[10] public myFixedSizeArr;


    function get(uint256 i) public view returns (uint256) {
        return arr1[i];
    }

    //Solidity可以返回整个数组。
    //但应避免使用此功能
    //长度可以无限增长的数组。
    function getArr() public view returns (uint256[] memory) {
        return arr1;
    }

    function push(uint256 i) public {
        // 添加一个元素
        // 这将使数组长度增加1。
        arr1.push(i);
    }

    function pop() public {
        //从数组中删除最后一个元素
        //这将使数组长度减少1
        arr1.pop();
    }

    function getLength() public view returns (uint256) {
        return arr1.length;
    }

    function remove(uint256 index) public {
        //删除不会改变数组长度。
        //它将索引处的值重置为默认值，
        //在这种情况下为0
        delete arr1[index];
    }

    function examples() external {
        // 在内存中创建数组，只能创建固定大小的数组
        uint256[] memory a = new uint256[](5);
    }

}