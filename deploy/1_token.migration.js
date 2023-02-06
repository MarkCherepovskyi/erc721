const token = artifacts.require("ERC20Mock"); // todo use erc721 mock

module.exports = async (deployer) => {
  await deployer.deploy(token, "Mock", "Mock", 18);
};
