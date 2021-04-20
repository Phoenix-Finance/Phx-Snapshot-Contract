pragma solidity =0.5.16;

import "./Ownable.sol";

contract Storage {
    address public fnxToken = 0xdFd9e2A17596caD6295EcFfDa42D9B6F63F7B5d5;
    address public fnxCollateral = 0xf2E1641b299e60a23838564aAb190C52da9c9323;
    address public fptb = 0x239889F56ec46daE0Ecb921cD3B9c53209cB293E;

    address[] public fixedminepools = [0x3c67c69d8FDd13A7602D818f294F50ad4642cF71];
    address[] public pancakeswapLp = [0x71348818c62f2a4419025Ee118f69157B088bD6d];
    address[] public pancakeLpFnxMine = [0x704196a0Dd205F4714C28c75C4cf473ec2E2F283];
    mapping (address => bool) public pancakeLpDisable;
}