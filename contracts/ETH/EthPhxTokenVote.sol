pragma solidity =0.5.16;

import "./IERC20.sol";

contract PhxTokenVote {
    address public phxToken;

    constructor(address _phxToken)public{
        phxToken = _phxToken;
    }

    function getUserPhxBalance(address _user) external view returns (uint256) {
        return IERC20(phxToken).balanceOf(_user);
    }
}