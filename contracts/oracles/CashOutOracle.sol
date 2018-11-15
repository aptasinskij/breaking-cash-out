pragma solidity 0.4.24;

import "../platform/Named.sol";
import "../platform/Mortal.sol";
import "../platform/Component.sol";
import "./api/ACashOutOracle.sol";

contract CashOutOralce is ACashOutOracle, Named("cash-out-oracle"), Mortal, Component {

    constructor(address _config) Component(_config) public {}

    function onNextOpenCashOut(uint256 _commandId) public {
        emit OpenCashOut(_commandId);
    }

    function successOpen(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmOpen
    }

    function failOpen(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmFailOpen
    }

    function onNextValidateCashOut(uint256 _commandId, uint256 _sessionId, uint256 _toWithdraw, uint256[] _bills) public {
        emit ValidateCashOut(_commandId, _sessionId, _toWithdraw, _bills);
    }

    function successValidate(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmValidate
    }

    function failValidate(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmFailValidate
    }

    function onNextCloseCashOut(uint256 _commandId, uint256 _sessionId, uint256 _toWithdraw, uint256[] _bills) public {
        emit CloseCashOut(_commandId, _sessionId, _toWithdraw, _bills);
    }

    function successClose(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmClose
    }

    function failClose(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmFailClose
    }

    function onNextRollbackCashOut(uint256 _commandId) public {
        emit RollbackCashOut(_commandId);
    }

    function successRollback(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmRollback
    }

    function failRollback(uint256 _commandId) public {
        //TODO:implementation: add call to CashOutManager::confirmFailRollback
    }

}