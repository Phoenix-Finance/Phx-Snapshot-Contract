pragma solidity =0.5.16;

import "./Ownable.sol";

contract Storage {
    address public fnxToken = 0xeF9Cd7882c067686691B6fF49e650b43AFBBCC6B;
    address public fnxCollateral = 0x919a35A4F40c479B3319E3c3A2484893c06fd7de; 
    
    address[] public uniswapLp = [0x722885caB8be10B27F359Fcb225808fe2Af07B16];
    address[] public uniFnxMine = [0x702164396De92bF0f4a1315c00EFDb5a7ea287eC];
    mapping (address => bool) public uniswapLpDisable;

    address[] public sushiswapLp = [0xaa500101C73065f755Ba9b902d643705EF2523E3];
    address   public sushimine = 0xc2EdaD668740f1aA35E4D8f227fB8E17dcA888Cd;
    uint256[] public sushimineLpId = [86];
    mapping (address => bool) public sushiswapLpDisable;

    address public fptb = 0x7E605Fb638983A448096D82fFD2958ba012F30Cd;
    address[] public fixedminepools = [0x4e6005396F80a737cE80d50B2162C0a7296c9620,
                                       0xf1FF936B72499382983a8fBa9985C41cB80BE17D];
        

}