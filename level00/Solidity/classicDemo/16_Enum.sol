pragma solidity ^0.8.0;

contract Enum {
    enum Status {
        Pending,
        Shipped,
        Accepted,
        Rejected,
        Canceled
    }

    //默认值是中列出的第一个元素
    //类型的定义，在本例中为“Pending”
    Status public status;

    // Returns uint
    // Pending  - 0
    // Shipped  - 1
    // Accepted - 2
    // Rejected - 3
    // Canceled - 4
    function get() public view returns (Status) {
        return status;
    }

    //通过将uint传入输入来更新状态
    function set(Status _status) public {
        status = _status;
    }

    //可以像这样更新到特定的枚举
    function cancel() public {
        status = Status.Canceled;
    }

    //delete将枚举重置为其第一个值0
    function reset() public {
        delete status;
    }

}