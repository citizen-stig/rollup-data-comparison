const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("Rollup", function () {
    let rollup;

    const rootHash = "0x1c433e3e9626287515e1a1fcf9f8bf66ca6d3270a8b8589f9a7543b1f918353d";
    const transactions = Array.from(Array(1000).keys())
    const transactionsU256 = transactions.map(t => ethers.BigNumber.from(t));
    const transactionsRaw = "0x"
        + ethers.BigNumber.from(transactions.length).toHexString().replace("0x", "").padStart(4, '0')
        + transactionsU256.map(t => t.toHexString().replace("0x", "").padStart(4, '0')).join('')

    before(async function () {
        const Rollup = await ethers.getContractFactory("Rollup");
        rollup = await Rollup.deploy();
        await rollup.deployed();
    });

    it("Submit Raw", async function () {
        const result = await rollup.submitBatchRaw(rootHash, transactionsRaw);
        const submitReceipt = await ethers.provider.waitForTransaction(result.hash, 1, 1200000);
        console.log("Submit Raw: cumulative gas used:", submitReceipt.cumulativeGasUsed.toString());
    });

    it("Submit Pre Parsed", async function () {
        const result = await rollup.submitBatchPreParsed(rootHash, transactionsU256);
        const submitReceipt = await ethers.provider.waitForTransaction(result.hash, 1, 1200000);
        console.log("Submit Pre Parsed: cumulative gas used:", submitReceipt.cumulativeGasUsed.toString());

    })
});
