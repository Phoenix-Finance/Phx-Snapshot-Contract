
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./Storage.sol";
import "./IERC20.sol";
import "./Ownable.sol";

interface ICollateralPool {
     function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

interface IUniMinePool {
     function totalStakedFor(address addr) external view returns (uint256);
}

contract FnxVoteWan is Storage,Ownable{
    using SafeMath for uint256;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxCollateralBalance(address _user) public view returns (uint256) {
       return ICollateralPool(fnxCollateral).getUserInputCollateral(_user,fnxToken);
    }
    
   function fnxBalanceInWanswap(address _user) public view returns (uint256) {
        uint256 i = 0;
        uint256 total = 0;
        
        for(;i<wanswap.length;i++) {
            if(wanswapDisable[wanswap[i]]) {
                continue;
            }
            
            uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(wanswap[i]);
            if (LpFnxBalance == 0) {
                return 0;
            }
            if(IERC20(wanswap[i]).totalSupply()==0) {
                return 0;
            }
            
            uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(wanswap[i]).totalSupply());
            uint256 userLpBalance = IERC20(wanswap[i]).balanceOf(_user);

            total = total.add((userLpBalance).mul(fnxPerUni).div(1e12));
        }
        
        return total;
    }    
    
    function fnxBalanceAll(address _user) public view returns (uint256) {
        
       uint256 tokenNum = fnxTokenBalance(_user);
       uint256 colTokenNum = fnxCollateralBalance(_user);
       uint256 wanswapNum = fnxBalanceInWanswap(_user);
       uint256 total = tokenNum.add(colTokenNum).add(wanswapNum);
       
       return total;
    }

    function setFnx(address _fnxToken) public onlyOwner{
        fnxToken = _fnxToken;
    }
    
    function setOptionCol(address _collateral) public onlyOwner{
        fnxCollateral = _collateral;
    } 
    
    function setWanswap(address _wanswap) public onlyOwner{
        wanswap.push(_wanswap);
    } 
    
    function disableWanSwap(address _wanswap) public onlyOwner{
        wanswapDisable[_wanswap] = true;
    }
    
    function removeAll() public onlyOwner {
        for(uint256 i=0;i<wanswap.length;i++) {
            delete wanswapDisable[wanswap[i]];
        }
        wanswap.length = 0;
    }
    
    
}