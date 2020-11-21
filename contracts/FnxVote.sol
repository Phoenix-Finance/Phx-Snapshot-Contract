
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./IERC20.sol";

interface ICollateralPool {
        function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

contract FnxVote {
    
    using SafeMath for uint256;

    address public fnxToken = 0xeF9Cd7882c067686691B6fF49e650b43AFBBCC6B;
    address public uniswapPair = 0x722885caB8be10B27F359Fcb225808fe2Af07B16;
    address public fnxCollateral = 0x919a35A4F40c479B3319E3c3A2484893c06fd7de;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxBalanceInUniswap(address _user) public view returns (uint256) {
        uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(uniswapPair);
        if (LpFnxBalance == 0) {
            return 0;
        }
        uint256 userLpBalance = IERC20(uniswapPair).balanceOf(_user);
        if (userLpBalance == 0) {
            return 0;
        }
        uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(uniswapPair).totalSupply());

        return userLpBalance.mul(fnxPerUni).div(1e12);
    }

    function fnxCollateralBalance(address _user) public view returns (uint256) {
       return ICollateralPool(fnxCollateral).getUserInputCollateral(_user,fnxToken);
    }
    
    function fnxBalanceAll(address _user) public view returns (uint256) {
       uint256 tokenNum = fnxTokenBalance(_user);
       uint256 uniTokenNum = fnxBalanceInUniswap(_user);
       uint256 colTokenNum = fnxBalanceInUniswap(_user);
       return tokenNum.add(uniTokenNum).add(colTokenNum);
    }


}


  