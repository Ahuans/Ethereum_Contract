// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
contract Donate{
    //Donor information
    struct Donator{
        uint256 targetId;
        string name;
        address donator_addr;
        uint256 amount;
    }
    //Fundraising announcement information
    struct Board{
        uint256 id;
        string name;
        string context;
        address host;
        string hostname;
        uint256 targetAmount;
        uint256 totalAmount;
        bool expire;
    }
    
    bool public mutex;
    uint256  public boardIndex;
    mapping(address=>Donator[]) donator_info;
    Donator[] public donators;
    Board[] public boards;
    constructor(){
        boardIndex=0;
        mutex=false;
    }
    //Put out a announcement
    function createBoard(string calldata hostname,address  host,string calldata _name,string calldata _context,uint256  _targetAmount) public {
        require(host!=address(0),"invalid host address");
        require(!mutex,"Sorry, someone is creating the board. Pleas wait a minute and repeat");
        mutex=true;
        Board memory boardItem=Board(boardIndex,_name,_context,host,hostname,_targetAmount,0,false);
        ++boardIndex;
        boards.push(boardItem);
        mutex=false;
        
    }
    //Get the announcement information according to the fundraising announcement ID
    function getBoardInfo(uint256 _boardIndex) public view returns(Board memory)
    {
        require(!boards[_boardIndex].expire,"This board has expired");
        return boards[_boardIndex];
    }
    //Obtain announcement information based on the address of the publisher
    function getBoardsByAddr(address _hostAddr) public view returns (Board[] memory)
    {
        uint256 count;
        for (uint256 i = 0; i < boards.length; i++) {
            if(boards[i].host==_hostAddr){
                ++count;
            }
        }
        Board[] memory _boards=new Board[](count);
        uint256 index;
        for (uint256 i = 0; i < boards.length; i++) {
            if(boards[i].host==_hostAddr){
                _boards[index++]=boards[i];
                
            }
        }
        return _boards;
    }
    //Get all unexpired announcement
    function getAllBoardsUnExpir() public view returns(Board[] memory)
    {
        
        
        uint256 count;
        for (uint256 i = 0; i < boards.length; i++) {
            if(!boards[i].expire){
                ++count;
            }
        }
        Board[] memory _boards=new Board[](count);
        uint256 index;
        for (uint256 i = 0; i < boards.length; i++) {
            if(!boards[i].expire){
                _boards[index++]=boards[i];
                
            }
        }
        return _boards;
    }
    //Get all expired announcement
    function getAllBoardsExpir() public view returns(Board[] memory)
    {
        
        
        uint256 count;
        for (uint256 i = 0; i < boards.length; i++) {
            if(boards[i].expire){
                ++count;
            }
        }
        Board[] memory _boards=new Board[](count);
        uint256 index;
        for (uint256 i = 0; i < boards.length; i++) {
            if(boards[i].expire){
                _boards[index++]=boards[i];
            }
        }
        return _boards;
    }
    //Get information about all donations donated to an announcement
    function getDonatorInBoard(uint256 _boardIndex) public view returns(Donator[] memory)
    {
        
        uint256 count;
        for (uint256 i = 0; i < donators.length; i++) {
            if(donators[i].targetId == _boardIndex){
                ++count;
            }
        }
        Donator[] memory _donators=new Donator[](count);
        uint256 index;
        for (uint256 i = 0; i < donators.length; i++) {
            if(donators[i].targetId == _boardIndex){
                _donators[index++]=donators[i];
                
            }
        }
        return _donators;
    }
    //Get all fundraising information for an account address
    function getDonatorInfoByAddr(address _address) public view returns(Donator[] memory)
    {
        require(_address!=address(0),"invalid address");
        //  uint256 count;
        // for (uint256 i = 0; i < donators.length; i++) {
        //     if(donators[i].donator_addr==_address){
        //         ++count;
        //     }
        // }
        // Donator[] memory _donators=new Donator[](count);
        // uint256 index;
        // for (uint256 i = 0; i < donators.length; i++) {
        //     if(donators[i].donator_addr==_address){
        //         _donators[index++]=donators[i];
                
        //     }
        // }
        // return _donators;
        return donator_info[_address];
    }
    //Donation method
    function donate(uint256 _targetId,string calldata name,address _donator_addr,uint256 _amount) public {
        require(_donator_addr!=address(0),"invalid address");
        Donator memory _donator=Donator(_targetId,name,_donator_addr,_amount);
        donators.push(_donator);
        donator_info[_donator_addr].push(_donator);
        uint256 i;
        for(;i<boards.length;++i)
        {
            if(boards[i].id==_targetId)
            {
                boards[i].totalAmount+=_amount;
                if(boards[i].totalAmount>=boards[i].targetAmount)
                {
                    boards[i].expire=true;
                    
                }
                break;
            }
        }
        require(i<boards.length,"no such board!");
    }

}