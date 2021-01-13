const FnxVoteProxy = artifacts.require('FnxVoteProxy');
const FnxVote = artifacts.require('FnxVote');
const FnxVoteTest = artifacts.require('FnxVoteTest');
const MockTokenFactory = artifacts.require('TokenFactory');
const Token = artifacts.require("TokenMock");

const assert = require('chai').assert;
const Web3 = require('web3');
const config = require("../truffle.js");
const BN = require("bn.js");
var utils = require('./utils.js');

web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));
let address0 =  "0x0000000000000000000000000000000000000000";

/**************************************************
 test case only for the ganahce command
 ganache-cli --port=7545 --gasLimit=8000000 --accounts=10 --defaultBalanceEther=100000 --blockTime 1
 **************************************************/
contract('FnxVoteProxy', function (accounts){
    let mockFnxToken;
    let mockLpToken;
    let mockUniMineToken;
    let mockColToken;
    let mockSushiLpToken;

    let amount = web3.utils.toWei('1', 'ether');

    before("init", async()=>{

       fnxvoteproxy = await FnxVoteProxy.new();
       console.log("fnxVoteProxy address:", fnxvoteproxy.address);

        fnxvote = await FnxVote.new();
        console.log("fnxVote address:", fnxvote.address);

        let res = await fnxvoteproxy.setLogicContract(fnxvote.address);
        assert.equal(res.receipt.status,true);

        tokenFactory = await MockTokenFactory.new();
        console.log("tokenfactory address:",tokenFactory.address);

        await tokenFactory.createToken(18);
        mockFnxToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockFnxToken address:",mockFnxToken.address);

        await tokenFactory.createToken(18);
        mockLpToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockLpToken address:",mockLpToken.address);

        await tokenFactory.createToken(18);
        mockUniMineToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockUniMineToken address:",mockUniMineToken.address);

        await tokenFactory.createToken(18);
        mockColToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockColToken address:",mockColToken.address);

        await tokenFactory.createToken(18);
        mockSushiLpToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockSushiLpToken address:",mockColToken.address);

      await tokenFactory.createToken(18);
      mockSushimineLpToken = await Token.at(await tokenFactory.createdToken());
      console.log("mockSushimineLpToken address:",mockSushimineLpToken.address);
//////////////////////////////////////////////////////////////////////
       fnxvote = await FnxVote.at(fnxvoteproxy.address);

       res = await fnxvote.removeAll();
       assert.equal(res.receipt.status,true);

       res = await fnxvote.setFnx(mockFnxToken.address);
       assert.equal(res.receipt.status,true);

        res = await fnxvote.setUniswap(mockLpToken.address,mockUniMineToken.address);
        assert.equal(res.receipt.status,true);

        res = await fnxvote.setOptionCol(mockColToken.address);
        assert.equal(res.receipt.status,true);

        res = await fnxvote.setSushiSwap(mockSushiLpToken.address,address0);
        assert.equal(res.receipt.status,true);

    })

   it("[0010]vote from all of pools,should pass", async()=>{

     let i = 0;

    let val = new BN(amount);//.mul(new BN(i+1));
     ///FNX BALANCE SET
     //1
    res = await mockFnxToken.adminSetBalance(accounts[0], val);
    assert.equal(res.receipt.status,true);
    //2
    res = await mockFnxToken.adminSetBalance(mockLpToken.address, val.mul(new BN(2)));
    assert.equal(res.receipt.status,true);

    //1
    res = await mockFnxToken.adminSetBalance(mockSushiLpToken.address, val.mul(new BN(2)));
    assert.equal(res.receipt.status,true);

    //FNX COLLATERAL BALANCE SET
    //1
    res = await mockColToken.adminSetCol(accounts[0], mockFnxToken.address,val);
    assert.equal(res.receipt.status,true);

    //uni lp balance set
    res = await mockLpToken.adminSetBalance(accounts[0],val);
    assert.equal(res.receipt.status,true);

    //uni mine lp balance set
    res = await mockUniMineToken.adminSetStake(accounts[0],val);
    assert.equal(res.receipt.status,true);

    //sushi swap lp balance
    res = await mockSushiLpToken.adminSetBalance(accounts[0],val);
    assert.equal(res.receipt.status,true);

    let fnxintoken = await fnxvote.fnxTokenBalance(accounts[0]);
    console.log("fnx in token =" + Web3.utils.fromWei(fnxintoken));

     let fnxincol = await fnxvote.fnxCollateralBalance(accounts[0]);
     console.log("fnx in colleteral =" + Web3.utils.fromWei(fnxincol));

     let fnxinuni = await fnxvote.fnxBalanceInUniswap(accounts[0]);
     console.log("fnx in uni =" + Web3.utils.fromWei(fnxinuni));

     let fnxinsushi = await fnxvote.fnxBalanceInSushiSwap(accounts[0]);
     console.log("fnx in sushi =" + Web3.utils.fromWei(fnxinsushi));

    let voteAmount = await fnxvote.fnxBalanceAll(accounts[0]);
    console.log("fnx total=" + Web3.utils.fromWei(voteAmount));

		})

  it("[0020]added sushimine test,should pass", async()=>{
    let i = 0;

    let val = new BN(amount);//.mul(new BN(i+1));

    res = await fnxvote.removeAll();
    assert.equal(res.receipt.status,true);

    res = await fnxvote.setUniswap(mockLpToken.address,mockUniMineToken.address);
    assert.equal(res.receipt.status,true);

    res = await fnxvote.setSushiSwap(mockSushiLpToken.address,mockSushimineLpToken.address);
    assert.equal(res.receipt.status,true);


    //sushi swap lp balance
    res = await mockSushimineLpToken.adminSetStake(accounts[0],val);
    assert.equal(res.receipt.status,true);

    let fnxintoken = await fnxvote.fnxTokenBalance(accounts[0]);
    console.log("fnx in token =" + Web3.utils.fromWei(fnxintoken));

    let fnxincol = await fnxvote.fnxCollateralBalance(accounts[0]);
    console.log("fnx in colleteral =" + Web3.utils.fromWei(fnxincol));

    let fnxinuni = await fnxvote.fnxBalanceInUniswap(accounts[0]);
    console.log("fnx in uni =" + Web3.utils.fromWei(fnxinuni));

    let fnxinsushi = await fnxvote.fnxBalanceInSushiSwap(accounts[0]);
    console.log("fnx in sushi =" + Web3.utils.fromWei(fnxinsushi));

    let voteAmount = await fnxvote.fnxBalanceAll(accounts[0]);
    console.log("fnx total=" + Web3.utils.fromWei(voteAmount));
  })

  it("[0030] changed logic contract,should pass", async()=>{

    newFnxvote = await FnxVoteTest.new();
    console.log("fnxVote address:", fnxvote.address);

    let res = await fnxvoteproxy.setLogicContract(newFnxvote.address);
    assert.equal(res.receipt.status,true);

    fnxvote = await FnxVoteTest.at(fnxvoteproxy.address);
    let version = await fnxvote.getVersion();
    console.log("new version=" + version);

    assert.equal(version,2);

  })
})
