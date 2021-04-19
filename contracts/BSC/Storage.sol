pragma solidity =0.5.16;

import "./Ownable.sol";

contract Storage {
    address public fnxToken = 0xdFd9e2A17596caD6295EcFfDa42D9B6F63F7B5d5;
    address public fnxCollateral = 0xf2E1641b299e60a23838564aAb190C52da9c9323;
    
    address[] public pancakeswapLp = [0x71348818c62f2a4419025Ee118f69157B088bD6d];
    address[] public pancakeLpFnxMine = [0x704196a0Dd205F4714C28c75C4cf473ec2E2F283];
    mapping (address => bool) public pancakeLpDisable;
}