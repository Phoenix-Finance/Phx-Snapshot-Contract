
pragma solidity =0.5.16;

import "../ETH/SafeMath.sol";
import "../ETH/IERC20.sol";
import "../ETH/Storage.sol";
import "../ETH/Ownable.sol";


interface ICollateralPool {
    function getUserInputCollateral(address user,address collateral) external view returns (uint256);
}

interface IUniMinePool {
    function totalStakedFor(address addr) external view returns (uint256);
}

contract FnxVoteTest is Storage,Ownable {
    using SafeMath for uint256;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxBalanceInUniswap(address _user) public view returns (uint256) {
        uint256 total = 0;
        for(uint256 i=0;i<uniswap.length;i++){
            if(uniswapDisable[sushiswap[i]]) {
                continue;
            }

            uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(uniswap[i]);
            if (LpFnxBalance == 0) {
                continue;
            }
            if(IERC20(uniswap[i]).totalSupply()==0) {
                continue;
            }

            uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(uniswap[i]).totalSupply());

            uint256 userUnimineLpBalance = IUniMinePool(uniMine[i]).totalStakedFor(_user);
            uint256 userLpBalance = IERC20(uniswap[i]).balanceOf(_user);

            total = total.add((userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12));
        }
    }

    function fnxBalanceInSushiSwap(address _user) public view returns (uint256) {
        uint256 total = 0;
        for(uint256 i=0;i<sushiswap.length;i++){

            if(sushiswapDisable[sushiswap[i]]) {
                continue;
            }

            uint256 LpFnxBalance = IERC20(fnxToken).balanceOf(sushiswap[i]);
            if (LpFnxBalance == 0) {
                continue;
            }
            if(IERC20(sushiswap[i]).totalSupply()==0) {
                continue;
            }

            uint256 fnxPerUni = LpFnxBalance.mul(1e12).div(IERC20(sushiswap[i]).totalSupply());
            if(sushimine[i]!=address(0)) {
                uint256 userUnimineLpBalance = IUniMinePool(sushimine[i]).totalStakedFor(_user);
                uint256 userLpBalance = IERC20(sushiswap[i]).balanceOf(_user);
                total = total.add((userLpBalance.add(userUnimineLpBalance)).mul(fnxPerUni).div(1e12));
            } else {
                uint256 userLpBalance = IERC20(sushiswap[i]).balanceOf(_user);
                total = total.add(userLpBalance.mul(fnxPerUni).div(1e12));
            }
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


    function setOptionCol(address _collateral)  public onlyOwner{
        fnxCollateral = _collateral;
    }

    function setUniswap(address _uniswap,address _uniMine) public onlyOwner{
        uniswap.push(_uniswap);
        uniMine.push(_uniMine);
    }

    function disableUniswap(address _uniswap) public onlyOwner{
        uniswapDisable[_uniswap] = true;
    }

    function setSushiSwap(address _sushiswap,address _sushimine) public onlyOwner{
        sushiswap.push(_sushiswap);
        sushimine.push(_sushimine);
    }

    function removeAll() public onlyOwner {
        for(uint256 i=0;i<uniswap.length;i++){
            delete uniswapDisable[sushiswap[i]];
        }

        for(uint256 i=0;i<uniswap.length;i++){
            delete sushiswapDisable[sushiswap[i]];
        }

        sushiswap.length = 0;
        sushimine.length = 0;
        uniswap.length = 0;
        uniMine.length = 0;
    }

    function disableSushiSwap(address _sushiswap)  public onlyOwner{
        sushiswapDisable[_sushiswap] = true;
    }

    function getVersion() public pure returns (uint256)  {
        return 2;
    }
}


