
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./Ownable.sol";

interface ICollateralPool {
     function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

interface IUniMinePool {
     function totalStakedFor(address addr) external view returns (uint256);
}

contract FnxVote is Ownable{
    using SafeMath for uint256;

    address public fnxToken = 0xeF9Cd7882c067686691B6fF49e650b43AFBBCC6B;
    address public uniswap = 0x722885caB8be10B27F359Fcb225808fe2Af07B16;
    address public fnxCollateral = 0x919a35A4F40c479B3319E3c3A2484893c06fd7de;
    address public uniMine = 0x702164396De92bF0f4a1315c00EFDb5a7ea287eC;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxBalanceInUniswap(address _user) public view returns (uint256) {
        uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(uniswap);
        if (LpFnxBalance == 0) {
            return 0;
        }
        
        uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(uniswap).totalSupply());
        
        uint256 userLpBalance = IERC20(uniswap).balanceOf(_user);
        if (userLpBalance == 0) {
            return 0;
        }
        
        uint256 userUnimineLpBalance = IUniMinePool(uniMine).totalStakedFor(_user);

        return (userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12);
    }

    function fnxCollateralBalance(address _user) public view returns (uint256) {
       return ICollateralPool(fnxCollateral).getUserInputCollateral(_user,fnxToken);
    }
    
    function fnxBalanceAll(address _user) public view returns (uint256) {
       uint256 tokenNum = fnxTokenBalance(_user);
       uint256 uniTokenNum = fnxBalanceInUniswap(_user);
       uint256 colTokenNum = fnxCollateralBalance(_user);
       uint256 total = tokenNum.add(uniTokenNum).add(colTokenNum);
       
       return total;
    }

    function setPools(address _fnxToken,address _uniswap,address _collateral,address _uniMine) public onlyOwner{
        fnxToken = _fnxToken;
        uniswap = _uniswap;
        fnxCollateral = _collateral;
        uniMine = _uniMine;
    }
}


  