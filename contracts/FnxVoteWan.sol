
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

    address public fnxToken = 0xC6F4465A6a521124C8e3096B62575c157999D361;
    address public fnxCollateral = 0xe96E4d6075d1C7848bA67A6850591a095ADB83Eb;

    function fnxTokenBalance(address _user) public view returns (uint256) {
        return IERC20(fnxToken).balanceOf(_user);
    }

    function fnxCollateralBalance(address _user) public view returns (uint256) {
       return ICollateralPool(fnxCollateral).getUserInputCollateral(_user,fnxToken);
    }
    
    function fnxBalanceAll(address _user) public view returns (uint256) {
       uint256 tokenNum = fnxTokenBalance(_user);
       uint256 colTokenNum = fnxCollateralBalance(_user);
       uint256 total = tokenNum.add(colTokenNum);
       return total;
    }

    function setPools(address _fnxToken,address _collateral) public onlyOwner{
        fnxToken = _fnxToken;
        fnxCollateral = _collateral;
    }
}