// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Mapping {

    mapping(address => uint256) public myMapping;

    function get(address _address) public view returns (uint256) {
        return myMapping[_address];
    }

    function set(address _address, uint256 _value) public {
        myMapping[_address] = _value;
    }

    function remove(address _address) public {
        //不会真的删除，只是将值设置为0
        delete myMapping[_address];
    }

}

contract NestedMapping {

    mapping(address => mapping(address => uint256)) public myNestedMapping;

    function get(address _address1, address _address2) public view returns (uint256) {
        return myNestedMapping[_address1][_address2];
    }

    function set(address _address1, address _address2, uint256 _value) public {
        myNestedMapping[_address1][_address2] = _value;
    }

    function remove(address _address1, address _address2) public {
        delete myNestedMapping[_address1][_address2];
    }

}