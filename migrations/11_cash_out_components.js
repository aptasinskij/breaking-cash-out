var Config = artifacts.require("Config");
var CashOutLib = artifacts.require("CashOutLib");
var CashOutStorage = artifacts.require("CashOutStorage");
var CashOutManager = artifacts.require("CashOutManager");
var CashOutOralce = artifacts.require("CashOutOralce");
var CashOutController = artifacts.require("CashOutController");

module.exports = function (deployer) {
    deployer.deploy(CashOutLib);
    deployer.link(CashOutLib, CashOutStorage);
    deployer.deploy(CashOutController, Config.address);
    deployer.deploy(CashOutStorage, Config.address);
    deployer.deploy(CashOutManager, Config.address);
    deployer.deploy(CashOutOralce, Config.address);
};