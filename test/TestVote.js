
const FnxVote = artifacts.require('FnxVote');
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
contract('FnxVote', function (accounts){
    let mockToken;
    let amount = web3.utils.toWei('1', 'ether');
    let fnxTokenAddress = '0xeF9Cd7882c067686691B6fF49e650b43AFBBCC6B';

    before("init", async()=>{
        fnxvote = await FnxVote.new();
        console.log("fnxVote address:", fnxvote.address);

        tokenFactory = await MockTokenFactory.new();
        console.log("tokenfactory address:",tokenFactory.address);

        await tokenFactory.createToken(18);
        mockToken = await Token.at(await tokenFactory.createdToken());
        console.log("mockToken address:",mockToken.address);

       //set mine coin info
       let res = await fnxvote.setPools(mockToken.address,mockToken.address,mockToken.address,mockToken.address);
       assert.equal(res.receipt.status,true);

       let i = 0;
       for(i=0;i<accounts.length;i++) {
           res = await mockToken.adminSetBalance(accounts[i], amount);
           assert.equal(res.receipt.status,true);

           res = await mockToken.adminSetCol(accounts[i], fnxTokenAddress,amount);
           assert.equal(res.receipt.status,true);

           res = await mockToken.adminSetStake(accounts[i],amount);
           assert.equal(res.receipt.status,true);
       }

    })


   it("[0010]vote test,should pass", async()=>{
/*
      let preMinerBalance = await proxy.totalRewards(staker1);
      console.log("before mine balance = " + preMinerBalance);

      let res = await lpToken1.approve(proxy.address,stakeAmount,{from:staker1});
      res = await proxy.stake(stakeAmount,"0x0",{from:staker1});
      time1 = await tokenFactory.getBlockTime();
      console.log(time1.toString(10));

      //check totalStaked function
      let totalStaked = await proxy.totalStaked();
      assert.equal(totalStaked,stakeAmount);

      let bigin = await web3.eth.getBlockNumber();
      console.log("start block="+ bigin )
      await utils.pause(web3,bigin + 1);

      let time2 = await tokenFactory.getBlockTime();
      //console.log(time2.toString(10));

      let afterMinerBalance = await proxy.totalRewards(staker1);
      console.log("after mine balance = " + afterMinerBalance);

      let diff = web3.utils.fromWei(afterMinerBalance) - web3.utils.fromWei(preMinerBalance);
      //console.log("time diff=" + (time2 - time1));
      let timeDiff = time2 - time1;

      console.log("mine balance = " + diff);
      assert.equal(diff>=timeDiff&&diff<=diff*(timeDiff+1),true);
*/
		})


})
