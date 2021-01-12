pragma solidity =0.5.16;

import "./Ownable.sol";

contract Storage is Ownable{

    address public fnxToken = 0xC6F4465A6a521124C8e3096B62575c157999D361;
    address public fnxCollateral = 0xe96E4d6075d1C7848bA67A6850591a095ADB83Eb;
    
    address[] public wanswap = 
    [   0x4bbBAaA14725D157Bf9dde1e13F73c3F96343f3d, //FNX/WAN
        0xfE5486f20826c3199bf6b68E05a49775C823A1D8, //FNX/wFNX  
        0x7ccACf0D5E0F3cFD701b66414970c09f61E2eC78, //WASP/FNX
        0x201C56Da77F2B4d4BED38E672196c50Ecc4e18c1, //FNX/USDT  
        0xC611EE52788d66312F3eA83d9ae96B693a611Ee8 //FNX/ETH   
    ];
    
}