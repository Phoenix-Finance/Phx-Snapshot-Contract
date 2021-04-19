
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./Storage.sol";
import "./Ownable.sol";


interface ICollateralPool {
     function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

interface IPancakeLpMinePool {
     function totalStakedFor(address addr) external view returns (uint256);
}

contract FnxVoteBsc is Storage,Ownable {
    using SafeMath for uint256;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxBalanceInPancakeSwap(address _user) public view returns (uint256) {
        uint256 total = 0;
        for(uint256 i=0;i<pancakeswapLp.length;i++){
            if(pancakeLpDisable[pancakeswapLp[i]]) {
                continue;
            }
            uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(pancakeswapLp[i]);
            if (LpFnxBalance == 0) {
                continue;
            }
            if(IERC20(pancakeswapLp[i]).totalSupply()==0) {
                continue;
            }
            
            uint256 fnxPerLp = LpFnxBalance.mul(1e12).div(IERC20(pancakeswapLp[i]).totalSupply());
            uint256 userPancakemineLpBalance = IPancakeLpMinePool(pancakeLpFnxMine[i]).totalStakedFor(_user);
            uint256 userLpBalance = IERC20(pancakeswapLp[i]).balanceOf(_user);
    
            total = total.add((userLpBalance.add(userPancakemineLpBalance)).mul(fnxPerLp).div(1e12));
        }
        
        return total;
    }

    function fnxCollateralBalance(address _user) public view returns (uint256) {
       return ICollateralPool(fnxCollateral).getUserInputCollateral(_user,fnxToken);
    }
    
    function fnxBalanceAll(address _user) public view returns (uint256) {
       uint256 tokenNum = fnxTokenBalance(_user);
       uint256 pancakeTokenNum = fnxBalanceInPancakeSwap(_user);
       uint256 colTokenNum = fnxCollateralBalance(_user);
       uint256 total = tokenNum.add(pancakeTokenNum).add(colTokenNum);
       return total;
    }

    function setFnx(address _fnxToken) public onlyOwner{
        fnxToken = _fnxToken;
    }

    function setOptionCol(address _collateral)  public onlyOwner{
        fnxCollateral = _collateral;
    }
        
    function setPancakeswap(address _pancakeswap,address _pancakelpMine) public onlyOwner{
        pancakeswapLp.push(_pancakeswap);
        pancakeLpFnxMine.push(_pancakelpMine);
    }

    function disablePancakeswap(address _pancakeswap) public onlyOwner{
        pancakeLpDisable[_pancakeswap] = true;
    }

    function removeAll() public onlyOwner {
        for(uint256 i=0;i<pancakeswapLp.length;i++){
            delete pancakeLpDisable[pancakeswapLp[i]];
        }
        pancakeswapLp.length = 0;
        pancakeLpFnxMine.length = 0;
    }

}


  