const { accounts, wei } = require("../../../scripts/utils/utils");
const { assert } = require("chai");

const MyToken = artifacts.require("MyToken");

describe("MyToken", () => {
  let OWNER;
  let SECOND;
  let token;

  before(async () => {
    OWNER = await accounts(0);
    SECOND = await accounts(1);
    console.log(OWNER, " ", SECOND);
  });

  beforeEach("setup", async () => {
    token = await MyToken.new();
  });

  describe("constructor", () => {
    it("should set parameters correctly", async () => {
      assert.equal(await token.name(), "MyToken");
      assert.equal(await token.symbol(), "MTK");
    });
  });

  describe("safeMint", () => {
    it("should mint correctly", async () => {
      assert.equal(await token.balanceOf(SECOND), "0");
      await token.safeMint(SECOND, "test");
      assert.equal(await token.tokenURI(0), "test");
      assert.equal(await token.balanceOf(SECOND), "1");
    });
  });

  describe("burn", () => {
    it("should burn correctly", async () => {
      await token.safeMint(SECOND, "test");
      await token.burn(0);
      console.log(await token.balanceOf(SECOND), "te");
      assert.equal(await token.balanceOf(SECOND), "0");
    });
  });
});
