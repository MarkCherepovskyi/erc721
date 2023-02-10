const { accounts, wei } = require("../../../scripts/utils/utils");
const { assert } = require("chai");

const MyToken = artifacts.require("MyToken");

describe("MyToken", () => {
  let OWNER;
  let SECOND;
  let FIFTY;
  let token;

  before(async () => {
    OWNER = await accounts(0);
    SECOND = await accounts(1);
    FIFTY = await accounts(5);
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
      assert.equal(await token.tokenURI(0), "ipfs://test");
      assert.equal(await token.balanceOf(SECOND), "1");
    });
    // it("get token ID", async()=>{
    //   await token.safeMint(SECOND, "test");
    //   const mint = await token.safeMint(SECOND, "test");
    //   console.log(mint)
    //   assert.equal(await token.tokenURI(0), "test");
    // })
  });

  describe("burn", () => {
    it("should burn correctly", async () => {
      await token.safeMint(SECOND, "test");
      await token.burn(0);
      console.log(await token.balanceOf(SECOND), "te");
      assert.equal(await token.balanceOf(SECOND), "0");
    });
  });

  describe("owners management", () => {
    it("owner", async () => {
      await token.safeMint(SECOND, "test", { from: OWNER });
      assert.equal(await token.balanceOf(SECOND), "1");
      await token.burn(0);
    });
    it("isn't owner", async () => {
      assert.equal(await token.balanceOf(SECOND), "0");
      await token.safeMint(SECOND, "test", { from: SECOND });
      assert.equal(await token.balanceOf(SECOND), "1");
      await token.burn(0);
    });
    it("new owner", async () => {
      await token.setNewAdmin(SECOND);
      await token.safeMint(SECOND, "test", { from: SECOND });
      assert.equal(await token.balanceOf(SECOND), "1");
      await token.burn(0);
    });
    it("delete owner", async () => {
      await token.deleteAdmin(SECOND);
      await token.safeMint(SECOND, "test", { from: SECOND });
      assert.equal(await token.balanceOf(SECOND), "1");
      await token.burn(0);
    });
  });

  describe("transfer", () => {
    it.only("transfer", async () => {
      await token.safeMint(SECOND, "test");
      await token.transferToken(SECOND, OWNER, 0), { from: OWNER };

      assert.equal(await token.balanceOf(SECOND), "0");
      assert.equal(await token.balanceOf(OWNER), "1");
      await token.burn(0);
    });
  });
  describe("transfer", () => {
    it.only("transfer without permission", async () => {
      await token.safeMint(SECOND, "test");
      await token.transferToken(SECOND, OWNER, 0, { from: SECOND });

      assert.equal(await token.balanceOf(SECOND), "0");
      assert.equal(await token.balanceOf(OWNER), "1");
      await token.burn(0);
    });
  });
});
