// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Donate{
    
    struct Donator{
        uint256 targetId;
        string name;
        address donator_addr;
        uint256 amount;
    }
    struct Board{
        uint256 id;
        string name;
        string context;
        address host;
        string hostname;
        uint256 targetAmount;
        uint256 totalAmount;
    }
    
    
    uint256 public boardIndex;
    Donator[] public donators;
    Board[] public boards;
    constructor(){
        boardIndex=0;
    }
    function createBoard(string calldata hostname,address  host,string calldata _name,string calldata _context,uint256  _targetAmount) public {
        Board memory boardItem=Board(boardIndex,_name,_context,host,hostname,_targetAmount,0);
        boards.push(boardItem);
    }
    function getBoardInfo(uint256 _boardIndex) public view returns(Board memory)
    {
        return boards[_boardIndex];
    }
    function getAllBoards() public view returns(Board[] memory)
    {
        return boards;
    }
    
}