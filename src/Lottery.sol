pragma solidity ^0.8.13;
import "forge-std/console.sol";
contract Lottery{
    uint256 _earnedEther;
    uint16 _winningNumber;
    uint16 _userNumber;
    address[] userarray;
    address[] _winners;
    uint256 startime;

    bool phase_checker;

    mapping(address => uint16[]) a;
    constructor () {
        _earnedEther = 0;
        _winningNumber = 1;
        startime = block.timestamp;
        phase_checker = false;
    }

    function buy(uint16 userNumber) payable public{
        require(block.timestamp < startime + 24 hours);
        require(msg.value == 0.1 ether);
        require(dupleCheck(userNumber) == true);
        _earnedEther += msg.value;

        if(arrayInCheck(msg.sender))
            userarray.push(msg.sender);
        a[msg.sender].push(userNumber);

        phase_checker = false;
    }
    function draw()public{
        require(block.timestamp >= startime + 24 hours);
        require(phase_checker == false);

        for(uint i = 0; i < userarray.length; i++){
            for(uint k = 0; k < a[userarray[i]].length; k++){
                if(a[userarray[i]][k] == _winningNumber)
                    _winners.push(userarray[i]);
            }
        }
    }
    function claim() public payable{
        require(block.timestamp >= startime + 24 hours);
        for(uint i = 0; i < _winners.length; i++){
            address payable owner = payable(_winners[i]);
            owner.send(_earnedEther / _winners.length);
            owner.call{value: _earnedEther / _winners.length}("");
        }

        if(_winnercheck(msg.sender))
            _winners.pop();
        if(_winners.length == 0)
            startime = block.timestamp;
        phase_checker = true;
    }

    function winningNumber() public view returns(uint16 winnum){
        return _winningNumber;
    }

    function arrayInCheck(address sender) internal returns(bool){
        for (uint i = 0; i < userarray.length; i++) {
            if (userarray[i] == sender)
                return false;
        }

        return true;
    }

    function _winnercheck(address sender) internal returns(bool){
        for (uint i = 0; i < _winners.length; i++) {
            if (_winners[i] == sender)
                return true;
        }

        return false;
    }

    function dupleCheck(uint16 selectedNum) internal returns(bool){
        for (uint i = 0; i < a[msg.sender].length; i++) {
            if (a[msg.sender][i] == selectedNum)
                return false;
        }

        return true;
    }
    
}