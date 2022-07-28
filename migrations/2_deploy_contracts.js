//const HelloName = artifacts.require("HelloName");
const Strings = artifacts.require("Strings");
const Block4SC = artifacts.require("Block4SC");

module.exports = function (deployer) {
  //deployer.deploy(HelloName);
  deployer.deploy(Strings);
  deployer.deploy(Block4SC);
};