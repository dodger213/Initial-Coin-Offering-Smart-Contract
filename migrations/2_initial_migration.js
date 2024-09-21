const MyToken = artifacts.require("MyToken");
const Presale = artifacts.require("Presale");

module.exports = function (deployer) {
  deployer.deploy(MyToken)

  //Deploy presale contract
  .then(function(){
    return deployer.deploy(Presale, MyToken.address)
  });
};
