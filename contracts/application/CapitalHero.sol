pragma solidity 0.4.24;

import "../platform/Context.sol";
import "../controllers/api/ACashInController.sol";
import "../controllers/api/ASessionController.sol";
import "../controllers/api/public/KioskApi.sol";
import "../controllers/api/public/CashOutApi.sol";

contract CapitalHero {

    string constant CONTROLLER = "cash-in-controller";

    Context private context;

    constructor(address _context) public {
        context = Context(_context);
    }

    event RequestSended(uint256 _sessionId, uint256 _maxBalance);
    event CashInOpened(uint256 _sessionId, uint256 _cashInId);
    event CashInUpdate(uint256 _sessionId, uint256 _cashInId, uint256 _amount);
    event CashInFail(uint256 _sessionId);

    function open(uint256 _sessionId, uint256 _maxBalance) public {
        ACashInController(context.get(CONTROLLER)).openCashInChannel(
            _sessionId, 
            _maxBalance, 
            this._openSuccess, 
            this._balanceUpdate, 
            this._openFail
        );
        emit RequestSended(_sessionId, _maxBalance);
    }

    function _openFail(uint256 _sessionId) public {
        emit CashInFail(_sessionId);
    }

    function _openSuccess(uint256 _sessionId, uint256 _cashInId) public {
        emit CashInOpened(_sessionId, _cashInId);
    }

    function _balanceUpdate(uint256 _sessionId, uint256 _cashInId, uint256 _amount) public {
        emit CashInUpdate(_sessionId, _cashInId, _amount);
    }

    event SessionCloseAccepted(uint256 _sessionId);
    event SessionCloseSuccess(uint256 _sessionId);
    event SessionCloseFail(uint256 _sessionId);

    function closeSession(uint256 _sessionId) public {
        ASessionController(context.get("session-controller")).closeSession(_sessionId, this.__successSessionClose, this.__failSessionClose);
        emit SessionCloseAccepted(_sessionId);
    }

    function __successSessionClose(uint256 _sessionId) public {
        emit SessionCloseSuccess(_sessionId);
    }

    function __failSessionClose(uint256 _sessionId) public {
        emit SessionCloseFail(_sessionId);
    }

    event GetKioskInfoAccepted(uint256 _sessionId);
    event GetKioskInfoSuccess(
        uint256 _sessionId, 
        string _id,
        string _location,
        string _name,
        string _timezone,
        uint256[] _bills,
        uint256[] _amounts    
    );
    event GetKioskInfoFail(uint256 _sessionId);

    function getKioskInfo(uint256 _sessionId) public {
        KioskApi(context.get("kiosk-controller")).getKiosk(_sessionId, this.__kioskInfoSuccess, this.__kioskInfoFail);
    }

    function __kioskInfoSuccess(
        uint256 _sessionId,
        string _id,
        string _location,
        string _name,
        string _timezone,
        uint256[] _bills,
        uint256[] _amounts
    ) 
        public 
    {
        emit GetKioskInfoSuccess(_sessionId, _id, _location, _name, _timezone, _bills, _amounts);
    }

    function __kioskInfoFail(
        uint256 _sessionId
    ) 
        public 
    {
        emit GetKioskInfoFail(_sessionId);
    }

    /*
        Example of CashOutApi workflow
    */

    string constant CASH_OUT_API = "cash-out-controller";

    // Open cash out components:

    event OpenCashOutAccepted();
    event OpenCashOutSuccess(string _requestId, string _kioskId, uint256 _cashOutId, uint256 _fee);
    event OpenCashOutFailed(string _kioskId, string _requestId);
    
    function openCashOut(
        string _requestId,
        string _kioskId, 
        uint256 _toWithdraw, 
        uint256[] _fees, 
        address[] _parties
    ) 
        public 
    {
        CashOutApi(context.get(CASH_OUT_API)).openCashOutChannel(
            _requestId, 
            _kioskId, 
            _toWithdraw, 
            _fees, 
            _parties, 
            this.__failOpenCashOut, 
            this.__successOpenCashOut
        );
        emit OpenCashOutAccepted();
    }

    function __successOpenCashOut(string _requestId, string _kioskId, uint256 _cashOutId, uint256 _fee) public {
        emit OpenCashOutSuccess(_requestId, _kioskId, _cashOutId, _fee);
    }

    function __failOpenCashOut( string _requestId, string _kioskId) public {
        emit OpenCashOutFailed(_requestId, _kioskId);
    }

    // Validate cash out components:

    event ValidateCashOutAccepted();
    event ValidateCashOutSuccess(uint256 _sessionId, uint256 _cashOutId);
    event ValidateCashOutFailed(uint256 _sessionId, uint256 _cashOutId);

    function validateCashOut(uint256 _sessionId, uint256 _cashOutId) public {
        CashOutApi(context.get(CASH_OUT_API)).validateCashOutChannel(
            _sessionId, 
            _cashOutId, 
            this.__failValidateCashOut,
            this.__successValidateCashOut
        );
        emit ValidateCashOutAccepted();
    }

    function __successValidateCashOut(uint256 _sessionId, uint256 _cashOutId) public {
        emit ValidateCashOutSuccess(_sessionId, _cashOutId);
    }

    function __failValidateCashOut(uint256 _sessionId, uint256 _cashOutId) public {
        emit ValidateCashOutFailed(_sessionId, _cashOutId);
    }

    // Close cash out components:

    event CloseCashOutAccepted();
    event CloseCashOutSuccess(uint256 _sessionId, uint256 _cashOutId);
    event CloseCashOutFailed(uint256 _sessionId, uint256 _cashOutId);

    function closeCashOut(uint256 _sessionId, uint256 _cashOutId) public {
        CashOutApi(context.get(CASH_OUT_API)).closeCashOutChannel(
            _sessionId, 
            _cashOutId, 
            this.__failCloseCashOut,
            this.__successCloseCashOut
        );
        emit CloseCashOutAccepted();
    }

    function __successCloseCashOut(uint256 _sessionId, uint256 _cashOutId) public {
        emit CloseCashOutSuccess(_sessionId, _cashOutId);
    }

    function __failCloseCashOut(uint256 _sessionId, uint256 _cashOutId) public {
        emit CloseCashOutFailed(_sessionId, _cashOutId);
    }

    // Rollback cash out components:

    event RollbackCashOutAccepted();
    event RollbackCashOutSuccess(uint256 _cashOutId);
    event RollbackCashOutFailed(uint256 _cashOutId);

    function rollbackCashOut(uint256 _cashOutId) public {
        CashOutApi(context.get(CASH_OUT_API)).rollbackCashOutChannel(
            _cashOutId, 
            this.__failRollbackCashOut,
            this.__successRollbackCashOut
        );
        emit RollbackCashOutAccepted();
    }

    function __successRollbackCashOut(uint256 _cashOutId) public {
        emit RollbackCashOutSuccess(_cashOutId);
    }

    function __failRollbackCashOut(uint256 _cashOutId) public {
        emit RollbackCashOutFailed(_cashOutId);
    }

}