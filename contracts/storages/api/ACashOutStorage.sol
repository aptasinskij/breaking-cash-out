pragma solidity 0.4.24;

import "../libs/CashOutLib.sol";

contract ACashOutStorage {

    function createCashOut(
        address _application
    )
        public 
        returns (
            uint256 _cashOutId
        );

    function createOpen(
        uint256 _cashOutId,
        string _requestId,
        string _kioskId,
        function(string memory, string memory) external _fail,
        function(string memory, string memory, uint256, uint256) external _success
    )
        public;

    function createAccount(
        uint256 _cashOutId,
        uint256 _toWithdraw,
        uint256 _VLFee,
        uint256 _reserve,
        uint256[] _fees,
        address[] _parties
    )
        public;

    function createValidate(
        uint256 _cashOutId,
        uint256 _sessionId,
        function(uint256, uint256) external _fail,
        function(uint256, uint256) external _success
    )
        public;

    function createClose(
        uint256 _cashOutId,
        uint256 _sessionId,
        function(uint256, uint256) external _fail,
        function(uint256, uint256) external _success
    )
        public;

    function createRollback(
        uint256 _cashOutId,
        function(uint256) external _fail,
        function(uint256) external _success
    )
        public;

    function retrieveCashOut(
        uint256 _cashOutId
    )
        public 
        view
        returns (
            address _application,
            CashOutLib.Status _status
        );

    function retrieveAccount(
        uint256 _cashOutId
    )
        public
        view
        returns (
            uint256 _toWithdraw,
            uint256 _VLFee,
            uint256 _reserve,
            uint256[] _fees,
            address[] _parties
        );

    function retrieveOpen(
        uint256 _cashOutId
    )
        public
        view
        returns (
            string memory _requestId,
            string memory _kioskId,
            function(string memory, string memory) external _fail,
            function(string memory, string memory, uint256, uint256) external _success
        );

    function retrieveValidate(
        uint256 _cashOutId
    )
        public
        view
        returns (
            uint256 _sessionId,
            function(uint256, uint256) external _fail,
            function(uint256, uint256) external _success
        );

    function retrieveClose(
        uint256 _cashOutId
    )
        public
        view
        returns (
            uint256 _sessionId,
            function(uint256, uint256) external _fail,
            function(uint256, uint256) external _success
        );

    function retrieveRollback(
        uint256 _cashOutId
    )
        public
        view
        returns (
            function(uint256) external _fail,
            function(uint256) external _success
        );

}