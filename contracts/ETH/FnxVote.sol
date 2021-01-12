
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./Storage.sol";


interface ICollateralPool {
     function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

interface IUniMinePool {
     function totalStakedFor(address addr) external view returns (uint256);
}

contract FnxVote is Storage {
    using SafeMath for uint256;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxBalanceInUniswap(address _user) public view returns (uint256) {
        uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(uniswap);
        if (LpFnxBalance == 0) {
            return 0;
        }
        if(IERC20(uniswap).totalSupply()==0) {
            return 0;
        }
        
        uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(uniswap).totalSupply());

        uint256 userUnimineLpBalance = IUniMinePool(uniMine).totalStakedFor(_user);
        uint256 userLpBalance = IERC20(uniswap).balanceOf(_user);

        return (userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12);
    }
    
    function fnxBalanceInSushiSwap(address _user) public view returns (uint256) {
        uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(uniswap);
        if (LpFnxBalance == 0) {
            return 0;
        }
        if(IERC20(uniswap).totalSupply()==0) {
            return 0;
        }
        
        uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(uniswap).totalSupply());
        if(uniMine!=address(0)) {
            uint256 userUnimineLpBalance = IUniMinePool(uniMine).totalStakedFor(_user);
            uint256 userLpBalance = IERC20(uniswap).balanceOf(_user);
            return (userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12);
        } else {
            uint256 userLpBalance = IERC20(uniswap).balanceOf(_user);
            return userLpBalance.mul(fnxPerUni).div(1e12);
        }
    }    

    function fnxCollateralBalance(address _user) public view returns (uint256) {
       return ICollateralPool(fnxCollateral).getUserInputCollateral(_user,fnxToken);
    }
    
    function fnxBalanceAll(address _user) public view returns (uint256) {
       uint256 tokenNum = fnxTokenBalance(_user);
       uint256 uniTokenNum = fnxBalanceInUniswap(_user);
       uint256 colTokenNum = fnxCollateralBalance(_user);
       uint256 sushiTokenNum = fnxBalanceInSushiSwap(_user);
       uint256 total = tokenNum.add(uniTokenNum).add(colTokenNum).add(sushiTokenNum);
       
       return total;
    }

    function setFnx(address _fnxToken) public onlyOwner{
        fnxToken = _fnxToken;
    }
    
    function setUniswap(address _uniswap) public onlyOwner{
        uniswap = _uniswap;
    }
    
    function setOptionCol(address _collateral)  public onlyOwner{
        fnxCollateral = _collateral;
    }
        
    function setUniMine(address _uniMine) public onlyOwner{
        uniMine = _uniMine;
    }
    
    function setSushiSwap(address _sushiswap) public onlyOwner{
        sushiswap = _sushiswap;
    }
    
    function setSushiMine(address _sushimine) public onlyOwner{
        sushimine = _sushimine;
    }
    
    function getVersion() public pure returns (uint256)  {
        return 1;
    }
    
    
}


  