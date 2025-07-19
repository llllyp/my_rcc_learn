// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
/*
TodoList: 是类似便签一样功能的东西，记录我们需要做的事情，以及完成状态。
1.需要完成的功能
- 创建任务
- 修改任务名称
  - 任务名写错的时候
- 修改完成状态：
  - 手动指定完成或者未完成
  - 自动切换
    - 如果未完成状态下，改为完成
    - 如果完成状态，改为未完成
- 获取任务
2.思考代码内状态变量怎么安排？
思考 1：思考任务 ID 的来源？
    我们在传统业务里，这里的任务都会有一个任务 ID，在区块链里怎么实现？？
    答：传统业务里，ID 可以是数据库自动生成的，也可以用算法来计算出来的，比如使用雪花算法计算出 ID 等。在区块链里我们使用数组的 index 索引作为任务的 ID，也可以使用自增的整型数据来表示。
思考 2: 我们使用什么数据类型比较好？
    答：因为需要任务 ID，如果使用数组 index 作为任务 ID。则数据的元素内需要记录任务名称，任务完成状态，所以元素使用 struct 比较好。
    如果使用自增的整型作为任务 ID，则整型 ID 对应任务，使用 mapping 类型比较符合。
*/
contract TodoList {
    struct Todo {
        string name;
        bool completed;
    }

    Todo[] public todos;
    // 创建任务
    function createTodo(string memory name) {
        // 创建任务, 默认未完成
        todos.push(Todo(name, false));
    }
    // 修改任务名称 1
    function updateName1(uint8 _index, string memory newName) {
        // 1. 先判断索引是否越界
        require(_index < todos.length, "Index out of range");
        // 方法1: 直接修改，修改一个属性时候比较省 gas
        list[_index].name = newName;
    }
    // 修改名称 2
    function updateName2(uint8 _index, string memory newName) {
        // 1. 先判断索引是否越界
        require(_index < todos.length, "Index out of range");
        // 方法2: 先获取储存到 storage，在修改，在修改多个属性的时候比较省 gas
        Todo storage temp = list[_index];
        temp.name = newName;
    }

    // 修改状态(手动指定状态)
    function modiStatus1(uint8 _index, bool _completed) {
        // 1. 先判断索引是否越界
        require(_index < todos.length, "Index out of range");
        // 方法1: 直接修改，修改一个属性时候比较省 gas
        todos[_index].completed = _completed;
    }

    // 修改状态(自动切换)
    function modiStatus2(uint8 _index) {
        // 1. 先判断索引是否越界
        require(_index < todos.length, "Index out of range");
        // 方法 2: 自动切换
        todos[_index].completed = !todos[_index].completed;
    }

    // 获取任务1 memory 两次拷贝
    function getTodo1(uint8 _index) external view returns(string memory _name, bool _completed) {
        Todo memory temp = todos[_index];
        return (temp.name, temp.completed);
    }

    // 获取任务 2 storage 一次拷贝 gas费用跟低
    function getTodo2(uint8 _index) external view returns(string memory _name, bool _completed) {
        Todo storage temp = list[index_];
        return (temp.name,temp.completed);
    }
    /*
    memory:
        内存
        是临时的，当函数调用结束后数据就会消失
    storage:
        存储
        数据永久存储在区块链上，通常用于状态变量。
    calldata:
        调用 
        数据存储在一个专门用于存放函数参数的区域，这也是临时的。
     */

}
