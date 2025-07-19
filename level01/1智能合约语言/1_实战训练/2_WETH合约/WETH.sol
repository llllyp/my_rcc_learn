// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

/*
WETH 是包装 ETH 主币，作为 ERC20 的合约。 标准的 ERC20 合约包括如下几个
3 个查询
    balanceOf: 查询指定地址的 Token 数量
    allowance: 查询指定地址对另外一个地址的剩余授权额度
    totalSupply: 查询当前合约的 Token 总量
2 个交易
    transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
    这是一个写入方法，所以还会抛出一个 Transfer 事件。
    transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
2 个事件
    Transfer
    Approval
1 个授权
    approve: 授权指定地址可以操作调用者的最大 Token 数量。
 */

contract WETH {
    string public name = "Wrapped Ether";
    string public symbol = "WETH";
    // decimals 小数
    uint8 public decimals = 18;

    // 2 个事件
    // 交易事件
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 授权事件
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // Deposit 存款, 将钱放入银行
    event Deposit(address indexed toAds, uint256 amount);
    // Withdraw 取款
    event Withdraw(address indexed src, uint256 amount);

    // 指定地址的 Token 数量
    mapping(address => uint) public balanceOf;
    // 指定地址对另外一个地址的剩余授权额度
    mapping(address => mapping(address => uint)) public allowance;

    // 存钱交易
    function deposit() payable {
        // 给指定地址的余额进行累加
        balanceOf[msg.sender] += msg.value;
        // 触发存钱事件
        emit Deposit(msg.sender, msg.value);
    }
    // 取钱交易
    function withdraw(uint amount) public {
        // 校验,指定地址的余额是否大于本次要取的金额 
        // Insufficient balance 余额不足
        require(amount <= balanceOf[msg.sender], "Insufficient balance");
        balanceOf[msg.sender] -= amount;
        // 触发取钱事件
        emit Withdraw(msg.sender, amount);
    }

    // 查询当前合约余额
    function totalSupply(address _addr) public view returns(uint256) {
        return address(this).balance;
    }

    // 授权 approve
    function approve(address _spender, uint256 _value) {
        allowance[msg.sender][_spender] = _value;
    }

    // transfer: 从当前调用者地址发送指定数量的 Token 到指定地址。
    funciton transfer(address toAds, uint amount) public {
        transferFrom(msg.sender, toAds, amount);
    }

    // transferFrom: 当向另外一个合约地址存款时，对方合约必须调用 transferFrom 才可以把 Token 拿到它自己的合约中。
    function transferFrom(address _from, address _to, uint256 amount) public returns(bool) {
        // 校验余额
        require(amount <= balanceOf[_from], "Insufficient balance");
        // 授权转账, 校验授权余额
        if (_from != msg.sender) {
            require(amount <= allowance[_from][msg.sender], "Insufficient allowance");
        }
        // 余额操作
        balanceOf[_from] -= amount;
        balanceOf[_to] += amount;
        // 触发转账事件
        emit Transfer(_from, _to, amount);
        return true;
    }

    // 兜底回滚方法
    fallback() external payable {
        deposit();
    }

    // receive 交易
    receive() external payable {
        deposit();
    }
}