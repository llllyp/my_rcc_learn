// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

/*
Gas

交易需要支付多少 以太币

您支付“gas spent * gas price”的“以太”金额，其中

-“gas”是一个计算单位
-“gas spent”是指交易中使用的天然气总量
-“gas price”是指你愿意为每种天然气支付多少“以太(ether)”`

gas价格较高的交易在区块中具有更高的优先级。
未使用的gas将被退还。

gas限制
你可以消耗的汽油量有两个上限

-“gas limit”（您愿意用于交易的最大gas量，由您设置）
-“block gas limit”（区块中允许的最大gas量，由网络设置）

*/
contract Gas {

    uint256 public i = 0;
    //用完您发送的所有gas会导致您的交易失败。
    //状态更改将撤消。
    //已消耗的gas不予退还。
    function forever() public {
        while (true) {
            i += 1;
        }
    }

}
