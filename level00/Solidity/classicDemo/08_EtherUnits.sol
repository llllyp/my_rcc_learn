// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;
/*
交易以“以太币”支付。
就像一美元等于100美分一样，一个“以太”等于10（18）个 wei 。

*/
contract EtherUnits {

    uint public oneWei = 1 wei;
    // 1 wei is equal to 1
    bool public isOneWei = (oneWei == 1);

    uint256 public oneGwei = 1 gwei;
    // 1 Gwei is equal to 10^9 Gwei
    bool public isOneGwei = (oneGwei == 1e9);

    uint256 public oneEther = 1 ether;
    // 1 ether is equal to 10^18 wei
    bool public isOneEther = (oneEther == 1e18);

}
