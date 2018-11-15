pragma solidity 0.4.24;

contract AKioskOracle {

    event GetKioskInfo(uint256 _commandId, uint256 _sessionId);

    function onNextGetKioskInfo(uint256 _commandId, uint256 _sessionId) public;

    function successGetKioskInfo(
        uint256 _commandId,
        string _id,
        string _location,
        string _name,
        string _timezone,
        uint256[] _bills,
        uint256[] _amounts
    )
        public;

    function failGetKioskInfo(
        uint256 _commandId
    )
        public;

}