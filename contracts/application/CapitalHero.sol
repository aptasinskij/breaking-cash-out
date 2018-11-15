pragma solidity 0.4.24;

import "../platform/Context.sol";
import "../controllers/api/ACashInController.sol";
import "../controllers/api/ASessionController.sol";
import "../controllers/api/public/KioskApi.sol";

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

}