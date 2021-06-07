const PhxvoteSc = artifacts.require('PhxVoteSum');
const PhxTokenVote = artifacts.require('PhxTokenVote');
const MockTokenFactory = artifacts.require('TokenFactory');
const Token = artifacts.require("TokenMock");

const assert = require('chai').assert;
const Web3 = require('web3');
const config = require("../truffle.js");
const BN = require("bn.js");
var utils = require('./utils.js');

web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:7545"));


/**************************************************
 test case only for the ganahce command
 ganache-cli --port=7545 --gasLimit=8000000 --accounts=10 --defaultBalanceEther=100000 --blockTime 1
 **************************************************/
contract('PhxVote', function (accounts){
    let pnxvote;
    let voteSumInt;
    let amount = web3.utils.toWei('1', 'ether');

    before("init", async()=>{
        voteSumInt = await PhxvoteSc.new();

        tokenFactory = await MockTokenFactory.new();
        console.log("tokenfactory address:",tokenFactory.address);

        await tokenFactory.createToken(18);
        mockFnxToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockFnxToken address:",mockFnxToken.address);

        pnxtokenvote = await PhxTokenVote.new(mockFnxToken.address);
        console.log("phxVote address:", pnxtokenvote.address);

        let res = await voteSumInt.addphxsrc(pnxtokenvote.address);
        assert.equal(res.receipt.status,true);
    })


   it("[0010]vote from all of pools,should pass", async()=>{
     let count = 1;
     for(var i=0;i< count;i++) {
       let val = new BN(amount).mul(new BN(i));
       res = await mockFnxToken.adminSetBalance(accounts[i], val);
       assert.equal(res.receipt.status,true);

       let voteAmount = await voteSumInt.pnxBalanceAll(accounts[i]);
       console.log(voteAmount.toString());
       assert.equal(voteAmount.toString(),val.toString(),"value not equal")
     }

	})


})
