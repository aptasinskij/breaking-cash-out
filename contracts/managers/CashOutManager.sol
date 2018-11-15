pragma solidity 0.4.24;

import "../platform/Named.sol";
import "../platform/Mortal.sol";
import "./api/ACashOutManager.sol";
import "../platform/Component.sol";
import "../oracles/api/ACashOutOracle.sol";
import "../storages/api/ACashOutStorage.sol";
import "../controllers/api/ACashOutController.sol";

contract CashOutManager is ACashOutManager, Named("cash-out-manager"), Mortal, Component {

    string constant CONTROLLER = "cash-out-controller";
    string constant STORAGE = "cash-out-storage";
    string constant ORACLE = "cash-out-oracle";

    constructor(address _config) Component(_config) public {}

    function openCashOutChannel(
        address _application,
        string _kioskId,
        uint256 _toWithdraw,
        uint256[] _fees,
        address[] _parties,
        function(string memory) external _fail,
        function(string memory, uint256) external _success
    )
        public
    {
        //TODO:implementation: verify msg.sender is CashOutController
        ACashOutStorage cashOutStorage = ACashOutStorage(context.get(STORAGE));
        uint256 cashOutId = cashOutStorage.createCashOut(_application);
        cashOutStorage.createOpen(cashOutId, _kioskId, _fail, _success);
        cashOutStorage.createAccount(cashOutId, _toWithdraw, 100, 5000, _fees, _parties);
        //TODO:implementation: add call to CashOutOracle::onNextOpenCashOut
    }

    function validateCashOutChannel(
        address _application,
        uint256 _sessionId,
        uint256 _cashOutId,
        function(uint256, uint256) external _fail,
        function(uint256, uint256) external _success
    )
        public
    {
        //TODO:implementation: verify msg.sender is CashOutController
        //TODO:implementation: verify _application the owner of CashOut
        ACashOutStorage(context.get(STORAGE)).createValidate(_cashOutId, _sessionId, _fail, _success);
        //TODO:implementation: add call to CashOutOracle::onNextValidateCashOut
    }

    function closeCashOutChannel(
        address _application,
        uint256 _sessionId,
        uint256 _cashOutId,
        function(uint256, uint256) external _fail,
        function(uint256, uint256) external _success
    )
        public
    {
        //TODO:implementation: verify msg.sender is CashOutController
        //TODO:implementation: verify _application the owner of CashOut
        ACashOutStorage(context.get(STORAGE)).createClose(_cashOutId, _sessionId, _fail, _success);
        //TODO:implementation: add call to CashOutOracle::onNextCloseCashOut
    }

    function rollbackCashOutChannel(
        address _application,
        uint256 _cashOutId,
        function(uint256) external _fail,
        function(uint256) external _success
    )
        public
    {
        //TODO:implementation: verify msg.sender is CashOutController
        //TODO:implementation: verify _application the owner of CashOut
        ACashOutStorage(context.get(STORAGE)).createRollback(_cashOutId, _fail, _success);
    }

}