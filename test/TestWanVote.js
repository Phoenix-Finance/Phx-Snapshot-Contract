const FnxVoteProxy = artifacts.require('FnxVoteWanProxy');
const FnxVote = artifacts.require('FnxVoteWan');

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
    let mockColToken;
    let mockLpToken = [];

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
        mockColToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockColToken address:",mockColToken.address);



//////////////////////////////////////////////////////////////////////
       fnxvote = await FnxVote.at(fnxvoteproxy.address);

       res = await fnxvote.removeAll();
       assert.equal(res.receipt.status,true);

      let i = 0;
      for(i=0;i<6;i++){
        await tokenFactory.createToken(18);
        lpt = await Token.at(await tokenFactory.createdToken());
        console.log("lp address:", lpt.address);

        res = await fnxvote.setWanswap(lpt.address);
        assert.equal(res.receipt.status,true);

        mockLpToken.push(lpt);
      }

       res = await fnxvote.setFnx(mockFnxToken.address);
       assert.equal(res.receipt.status,true);

        res = await fnxvote.setOptionCol(mockColToken.address);
        assert.equal(res.receipt.status,true);

    })

   it("[0010]vote from all of pools,should pass", async()=>{

      let val = new BN(amount);//.mul(new BN(i+1));
       ///FNX BALANCE SET
       //1
      res = await mockFnxToken.adminSetBalance(accounts[0], val);
      assert.equal(res.receipt.status,true);

       //FNX COLLATERAL BALANCE SET
       //1
       res = await mockColToken.adminSetCol(accounts[0], mockFnxToken.address,val);
       assert.equal(res.receipt.status,true);

       for(i=0;i<6;i++){
         res = await mockFnxToken.adminSetBalance(mockLpToken[i].address, val);
         assert.equal(res.receipt.status,true);
         res = await mockLpToken[i].adminSetBalance(accounts[0], val);
         assert.equal(res.receipt.status,true);
       }

      let fnxintoken = await fnxvote.fnxTokenBalance(accounts[0]);
      console.log("fnx in token =" + Web3.utils.fromWei(fnxintoken));

       let fnxincol = await fnxvote.fnxCollateralBalance(accounts[0]);
       console.log("fnx in colleteral =" + Web3.utils.fromWei(fnxincol));

       let fnxinuni = await fnxvote.fnxBalanceInWanswap(accounts[0]);
       console.log("fnx in uni =" + Web3.utils.fromWei(fnxinuni));

      let voteAmount = await fnxvote.fnxBalanceAll(accounts[0]);
      console.log("fnx total=" + Web3.utils.fromWei(voteAmount));

		})


})
