pragma solidity =0.5.16;
import "./Ownable.sol";
import "./SafeMath.sol";

interface Iphxsrc {
    function getUserPhxBalance(address user) external view returns (uint256);
}
contract PhxVote is Ownable {

    using SafeMath for uint256;
    address[] public phxsource;

    function removeAll() public onlyOwner {
        phxsource.length = 0;
    }

    function remove(address _phxsrc) public onlyOwner {
        for(uint256 i=0;i<phxsource.length;i++){
            if(phxsource[i]==_phxsrc) {
                phxsource[i] = phxsource[phxsource.length-1];
                phxsource.length--;
                break;
            }
        }
    }

    function addphxsrc(address _phxsrc) public onlyOwner {
        phxsource.push(_phxsrc);
    }

    function pnxBalanceAll(address _user) public view returns (uint256) {
        uint256 totalphx = 0;
        for(uint256 i=0;i<phxsource.length;i++){
            totalphx = totalphx + Iphxsrc(phxsource[i]).getUserPhxBalance(_user);
        }
        return totalphx;
    }

}

