// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract BankVault is ERC20, Ownable {
    mapping(address => uint256) public depositTime;
    uint256 constant depositAmount = 1 wei;
    bool private isLocked;

    modifier nonReentrant() {
        require(!isLocked, "Reentrancy Guard");
        isLocked = true;
        _;
        isLocked = false;
    }

    constructor() ERC20("IntrestToken", "INTE") {}

    function deposit() external payable nonReentrant {
        require(depositTime[msg.sender] == 0, "User Already Deposited");
        require(msg.value >= depositAmount, "Insufficeint Deposit Fund");
        depositTime[msg.sender] = block.timestamp;
        _returnExcessETH();
    }

    function withdraw() external nonReentrant {
        require(depositTime[msg.sender] != 0, "User not found");
        uint256 tokenAmount = block.timestamp - depositTime[msg.sender];
        depositTime[msg.sender] = 0;
        mint(msg.sender, tokenAmount);
    }

    function mint(address to, uint256 amount) internal {
        _mint(to, amount);
    }

    function _returnExcessETH()internal{
        if(msg.value > depositAmount){
            uint256 amtReturn = msg.value - depositAmount;
            payable(msg.sender).transfer(amtReturn);
        }
    }

    function pendingReward(address _user) public view returns(uint256){
        uint256 rewards = block.timestamp - depositTime[_user];
        return rewards;
    }

    function withdrawETH(uint256 _amount) external onlyOwner {
        payable(owner()).transfer(_amount);
    }
}
