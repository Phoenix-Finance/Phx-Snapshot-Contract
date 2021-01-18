
pragma solidity =0.5.16;

import "./SafeMath.sol";
import "./IERC20.sol";
import "./Storage.sol";
import "./Ownable.sol";


interface ICollateralPool {
     function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

interface IUniMinePool {
     function totalStakedFor(address addr) external view returns (uint256);
}

interface ISushiMinePool {
     function userInfo(uint256 pid,address addr) external view returns (uint256,uint256);    
}

contract FnxVote is Storage,Ownable {
    using SafeMath for uint256;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxBalanceInUniswap(address _user) public view returns (uint256) {
        uint256 total = 0;
        for(uint256 i=0;i<uniswapLp.length;i++){
            if(uniswapLpDisable[uniswapLp[i]]) {
                continue;
            }
            
            uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(uniswapLp[i]);
            if (LpFnxBalance == 0) {
                continue;
            }
            if(IERC20(uniswapLp[i]).totalSupply()==0) {
                continue;
            }
            
            uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(uniswapLp[i]).totalSupply());
    
            uint256 userUnimineLpBalance = IUniMinePool(uniFnxMine[i]).totalStakedFor(_user);
            uint256 userLpBalance = IERC20(uniswapLp[i]).balanceOf(_user);
    
            total = total.add((userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12));
        }
        
        return total;
    }
    
    function fnxBalanceInSushiSwap(address _user) public view returns (uint256) {
        uint256 total = 0;
        for(uint256 i=0;i<sushiswapLp.length;i++){    
            
            if(sushiswapLpDisable[sushiswapLp[i]]) {
                continue;
            }
            
            uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(sushiswapLp[i]);
            if (LpFnxBalance == 0) {
                continue;
            }
            if(IERC20(sushiswapLp[i]).totalSupply()==0) {
                continue;
            }
            
            uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(sushiswapLp[i]).totalSupply());
            if(sushimine!=address(0)) {
                uint256 userUnimineLpBalance = 0;
                
                (userUnimineLpBalance,) = ISushiMinePool(sushimine).userInfo(sushimineLpId[i],_user);
                
                uint256 userLpBalance = IERC20(sushiswapLp[i]).balanceOf(_user);
                total = total.add((userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12));
            } else {
                uint256 userLpBalance = IERC20(sushiswapLp[i]).balanceOf(_user);
                total = total.add(userLpBalance.mul(fnxPerUni).div(1e12));
            }
        }
        
        return total;
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
    

    function setOptionCol(address _collateral)  public onlyOwner{
        fnxCollateral = _collateral;
    }
        
    function setUniswap(address _uniswap,address _uniMine) public onlyOwner{
        uniswapLp.push(_uniswap);
        uniFnxMine.push(_uniMine);
    }

    function disableUniswap(address _uniswap) public onlyOwner{
        uniswapLpDisable[_uniswap] = true;      
    }

    function setSushiSwap(address _sushiswap,uint256 _pid) public onlyOwner{
        sushiswapLp.push(_sushiswap);
        sushimineLpId.push(_pid);
    }

    function setSushiMine(address _sushimine) public onlyOwner{
        sushimine = _sushimine;
    }    

    function removeAll() public onlyOwner {
        for(uint256 i=0;i<uniswapLp.length;i++){
            delete uniswapLpDisable[sushiswapLp[i]];
        }
        
        for(uint256 i=0;i<uniswapLp.length;i++){
            delete sushiswapLpDisable[sushiswapLp[i]];
        }
        
        sushiswapLp.length = 0;
        uniswapLp.length = 0;
        uniFnxMine.length = 0;
    }    
    
    function disableSushiSwap(address _sushiswap)  public onlyOwner{
        sushiswapLpDisable[_sushiswap] = true;
    }

    function getVersion() public pure returns (uint256)  {
        return 1;
    }
    
    
}


  