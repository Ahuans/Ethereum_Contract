// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;
import './Context.sol';

contract Token is Context{
    //Tokenname
    string private _name;
    //Token symbol
    string private _symbol;
    //Token decimals
    uint8 private _decimals;
    //Token total amount
    uint256 private _totalSupply;
    // Token balance
    mapping(address => uint256) private _balances;
    //Token allowance
    mapping(address => mapping(address => uint256)) private _allowances;

    constructor()
    {
        _name= "Hessiacorn";
        _symbol="HSAC";
        _decimals=18;
        _mint(_msgSender(),100*10000*10**_decimals);
    }
    function name() public view returns (string memory){
        return _name;
    }
    function symbol() public view returns (string memory){
        return _symbol;
    }
    function decimals() public view returns (uint8){
        return _decimals;
    }
    function totalSupply() public view returns (uint256){
        return _totalSupply;
    }
    function balanceOf(address _owner) public view returns(uint256){
        return _balances[_owner];
    }
    function allowanceOf(address _owner,address _spender) public view returns(uint256){
        return _allowances[_owner][_spender];
    }

    function transfer(address _to, uint256 _value) public returns (bool){
        address owner=_msgSender();
        _transfer(owner,_to, _value);
        return true;
    }
     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
        address owner=_msgSender();
        _spenderAllowance(_from,owner,_value);
        _transfer(_from, _to, _value);
        return true;
     }
     function approve(address _spender, uint256 _value) public returns (bool){
        address _owner=_msgSender();
        _approve(_owner,_spender,_value);
        return true;
     }
    // function allowance(address _owner, address _spender) public view returns (uint256 remaining)
    // functions in contract
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

    function _mint(address account, uint256 amount) internal 
    {
        require(account!=address(0),"address is invalid");
        //initiate token amount
        _totalSupply+=amount;

        //push tokens into account
        unchecked{
            _balances[account]+=amount;
        } 
    }
    function _transfer(address from,address to, uint256 amount) internal {
        require(from!=address(0),"from address invalid!");
        require(to!=address(0),"to address invalid!");
        uint256 fromBalance=_balances[from];
        require(fromBalance >= amount,"ERC20:Insufficient balance!");
        unchecked{
            _balances[from]-=amount;
            _balances[to]+=amount;
        }
        emit Transfer(from, to, amount);
        
    }
    function _approve(address owner,address spender,uint256 amount) internal{
        require(owner!=address(0),"owner address invalid!");
        require(spender!=address(0),"spender address invalid!");
        _allowances[owner][spender]=amount;
        emit Approval(owner, spender, amount);
    }
    function _spenderAllowance(address _owner,address _spender,uint256 amount ) internal{
        uint256 currentAllowance=allowanceOf(_owner, _spender);
        if(currentAllowance!=type(uint256).max){
            require(currentAllowance >= amount,"ERC20:Insufficient balance!");
            unchecked{
                _approve(_owner,_spender,currentAllowance-amount);
            }
        }
    }
}