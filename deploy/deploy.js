const token = artifacts.require("sbt"); // todo use erc721 mock

module.exports = async () => {
  const MyToken = await ethers.getContractFactory("MyToken");
  await MyToken.deploy("MyToken", "MTK");
};
