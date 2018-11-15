pragma solidity 0.4.24;

import "../platform/Named.sol";
import "../platform/Mortal.sol";
import "../platform/Component.sol";
import "./api/ACashInController.sol";
import "../managers/api/ACashInManager.sol";

contract CashInController is ACashInController, Named("cash-in-controller"), Mortal, Component {

    string constant MANAGER = "cash-channels-manager";

    constructor(address _config) Component(_config) public {}

    function(uint256[] memory) external actual;

    function openCashInChannel(
        uint256 _sessionId,
        uint256 _maxBalance,
        function(uint256, uint256) external _success,
        function(uint256, uint256, uint256) external _update,
        function(uint256) external _fail
    )
        external
    {
        ACashInManager(context.get(MANAGER)).openCashInChannel(msg.sender, _sessionId, _maxBalance, _fail, _success, _update);
    }

    function respondOpened(uint256 _sessionId, uint256 _cashInId, function(uint256, uint256) external _callback) public {
        _callback(_sessionId, _cashInId);
    }

    function respondFailOpen(uint256 _sessionId, function(uint256) external _callback) public {
        _callback(_sessionId);
    }

    function respondUpdate(
        uint256 _sessionId,
        uint256 _cashInId,
        uint256 _amount,
        function(uint256, uint256, uint256) external _callback
    )
        public
    {
        _callback(_sessionId, _cashInId, _amount);
    }

    function closeCashInChannel(
        uint256 _sessionId,
        uint256 _channelId,
        uint256[] _fees,
        address[] _parties,
        function(uint256, uint256) external _success,
        function(uint256, uint256) external _fail
    )
        external
    {
        ACashInManager(context.get(MANAGER)).closeCashInChannel(msg.sender, _sessionId, _channelId, _fees, _parties, _success, _fail);
    }

    function respondClosed(uint256 _sessionId, uint256 _cashInId, function(uint256, uint256) external _callback) public {
        _callback(_sessionId, _cashInId);
    }

    function respondFailClose(uint256 _sessionId, uint256 _cashInId, function(uint256, uint256) external _callback) public {
        _callback(_sessionId, _cashInId);
    }

    function balanceOf(uint256 _channelId) public view returns (uint256) {
        return ACashInManager(context.get(MANAGER)).balanceOf(msg.sender, _channelId);
    }

}
