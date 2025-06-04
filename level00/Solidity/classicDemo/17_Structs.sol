// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Todos {

    struct Todo {
        string text;
        bool completed;
    }

    // An array of 'Todo' structs
    Todo[] public todos;

    function create(string calldata _text) public {
        //初始化结构体的三种方法
        //-像函数一样调用它
        todos.push(Todo(_text, false));

        //使用键值对初始化
        todos.push(Todo({text: _text, completed: false}));

        //使用内存变量
        Todo memory todo;
        todo.text = _text;
        // todo.completed initialized to false

        todos.push(todo);

    }

    //Solidity自动为“todos”创建了一个getter，所以
    //实际上并不需要这个功能。
    function get(uint256 _index) public view returns (string memory text, bool completed){
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    // update text
    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    // update completed
    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}