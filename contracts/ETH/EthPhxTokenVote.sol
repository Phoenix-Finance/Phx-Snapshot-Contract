pragma solidity =0.5.16;

import "./IERC20.sol";

contract EthPhxTokenVote {
    address public phxToken = 0xAeC65404DdC3af3C897AD89571d5772C1A695F22;
    function getUserPhxBalance(address _user) external view returns (uint256) {
        return IERC20(phxToken).balanceOf(_user);
    }
}