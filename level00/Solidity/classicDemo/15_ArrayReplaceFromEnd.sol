pragma solidity ^0.8.0;

contract ArrayReplaceFromEnd {

    uint256[] public arr;

    //删除元素会在阵列中创建间隙。
    //保持阵列紧凑的一个技巧是
    //将最后一个元素移动到要删除的位置。
    function remove(uint256 index) public {
        // Move the last element into the place to delete
        arr[index] = arr[arr.length - 1];
        // Remove the last element
        arr.pop();
    }

    function test() public {
        arr = [1, 2, 3, 4];

        remove(1);
        // [1, 4, 3]
        assert(arr.length == 3);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
        assert(arr[2] == 3);

        remove(2);
        // [1, 4]
        assert(arr.length == 2);
        assert(arr[0] == 1);
        assert(arr[1] == 4);
    }
}