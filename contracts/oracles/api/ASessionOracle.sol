pragma solidity 0.4.24;

contract ASessionOracle {

    event CloseSession(uint256 sessionId);

    function onNextCloseSession(uint256 sessionId) public;

    function successClose(uint256 _sessionId) public;

    function failClose(uint256 _sessionId) public;

}
