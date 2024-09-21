// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./ERC20.sol";
import "./Ownable.sol";
import "./Pausable.sol";
import "./Whitelist.sol";

/**
 * @author Roberto Agüera
 * @title  ICO Presale smart contract
 * @notice Presale contract to manage user funds which allows get funding for a project without intermediaries.
 *         Any user account should be whitelisted previously in order to be able to buy tokens, unless this
 *         functionality is disabled. User accounts may be added/removed to the whitelist with addToWhiteList(),
 *         addManyToWhitelist() and removeFromWhiteList() functions.
 *         Any whitelisted user may exchange his BNBs for tokens with buyTokens() function.
 *         It allows the owner to pause buyTokens() function if necessary.
 *         Once the presale ends, it allows to transfer funds to the owner, then the owner should send
 *         BNBs and TKNs to PancakeSwap through addLiquidityToPS() function.
 *         Once token funds are transferred to the owner, tokens are locked for X days.
 *
 * Requirements:
 *
 * - Token contract should be previously deployed, then deploy this presale contract by passing
 *   the Token contract address in the constructor. It is done automatically with Truffle
 */

contract Presale is Ownable, Pausable, Whitelist {

    // CONFIG START

    ERC20 public immutable token; // Token contract instance.

    mapping(address => bool) public contractsWhiteList;
    
    address payable presaleOwner; // Presale owner wallet address, which must be the same than Token contract owner address.
    address payable presaleContract;
    address private presaleLiquidityWallet = address(0); //Your presale liquidity wallet. This is the same wallet as the presaleLiquidityWallet on Token.sol
    
    uint256 private presaleRate = 4000; // How many TKNs can I buy with 1BNB.
    
    uint256 public presaleEndsDate = block.timestamp + 30 days; // When presale ends, nobody will be able to buy tokens from this contract.
    
    uint256 public constant minContribLimit = 400000000000000000; // The minimum purchase (0,4BNB) in Wei units
    uint256 public constant maxContribLimit = 10000000000000000000; // The maximum purchase (10BNB) in Wei units

    uint256 public constant hardCap = 500000000000000000000; // The maximum limit supply (500BNB) in Wei units

    /**
     * @dev After the presale ends, 60% of the presale funds will be added to the PancakeSwap liquidity.
     * 40% will be added to presaleOwner wallet.
     */
    uint8 private pancakeSwapLiquidityPercent = 60;

    // CONFIG END
    
    event BuyTokens (address, uint256, address, uint256);
    event TransferTokens (address, uint256);

    modifier onlyWhitelisted() {
        if(!whitelist()){
            _;
        }else{
            require(contractsWhiteList[msg.sender], "You are not whitelisted");
            _;
        }
    }
    
    constructor (address payable _tokenContract) payable {
        token = ERC20(_tokenContract);
        presaleOwner = payable(msg.sender);
        presaleContract = payable(address(this));
        token.setPresaleContractAddress();
        addLiquidityToPresale(presaleRate*hardCap);
    }

    /**
     * @dev Deposits BNB to get TKNs.
     */
    function buyTokens() public payable onlyWhitelisted whenNotPaused returns (bool) {
        require(block.timestamp < presaleEndsDate, "Presale has already finished");
        require(msg.value >= minContribLimit, "Insuficient funds. You need to send more BNBs");
        require(msg.value <= maxContribLimit, "Too much funds. You need to send less BNBs");
        require(presaleContractBNBBalance() <= hardCap, "You can't buy tokens. Hard Cap reached");
        uint256 _numTokensToBuy = tokenPrice(msg.value);
        require(_numTokensToBuy <= availableTokens(), "Insuficient liquidity. Buy less tokens");
        token.transfer(msg.sender, _numTokensToBuy);
        return true;
    }

    /**
     * @dev Transfers BNB and remaining TKNs to Token contract address.
     */
    function transferTokens() public payable onlyOwner {
        uint256 tokensSold = ((presaleRate * hardCap) - availableTokens());
        if(presaleContractBNBBalance() > 0){
            uint256 _lockedBalance = tokensSold * pancakeSwapLiquidityPercent / 100 / 2; // Presale amount locked
            (bool sent,) = msg.sender.call{value: presaleContractBNBBalance(), gas: 1000000}('');
            require(sent, "Failed to send BNB");
            (bool setLocked) = token.setLockedBalance(presaleLiquidityWallet, _lockedBalance);
            require(setLocked, "Failed to lock BNB");
        }

        if(availableTokens() > 0){
            token.transfer(owner(), availableTokens());
        }        
    }

    /**
     * @dev Returns the BNB balance of presale contract.
     */
    function presaleContractBNBBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Returns the TKNs balance of presale contract.
     */
    function availableTokens() public view returns (uint256) {
        return token.balanceOf(presaleContract);
    }

    receive() external payable {
        buyTokens();
    }

    /**
     * @dev Returns the equivalent TKNs of a BNB amount.
     */
    function tokenPrice(uint256 _BNBToSell) public payable returns (uint256) {
        return (_BNBToSell * presaleRate);
    }

    /**
     * @dev Adds TKN tokens liquidity to presale contract.
     */
    function addLiquidityToPresale(uint256 _amount) public returns (bool) {
        require(token.approvePresaleContract(_amount), "Add liquidity to presale contract is not allowed anymore");
        token.transferFrom(presaleOwner, presaleContract, _amount);
        return true;
    }

    /**
     * Returns the balance of an address.
     */
    function balanceOf(address _address) public view returns (uint) {
        return token.balanceOf(_address);
    }

    /**
     * Returns the allowance of an address.
     */
    function allowance(address _owner, address _spender) public view returns (uint256) {
        return token.allowance(_owner, _spender);
    }

    /**
     * Adds an address to the whitelist of presale contract.
     */
    function addToWhiteList(address _address) public onlyOwner {
        contractsWhiteList[_address] = true;
    }

    /**
     * Removes an address from the whitelist of presale contract.
     */
    function removeFromWhiteList(address _address) public onlyOwner {
        contractsWhiteList[_address] = false;
    }

    /**
     * Adds more than one address to the whitelist of presale contract.
     */
    function addManyToWhitelist(address[] memory _addresses) public onlyOwner {
        for (uint256 i = 0; i < _addresses.length; i++) {
            contractsWhiteList[_addresses[i]] = true;
        }
    }

    /**
     * Enables the whitelist.
     */
    function enableWhitelist() public onlyOwner {
        _enableWhitelist();
    }

    /**
     * Disables the whitelist.
     */
    function disableWhitelist() public onlyOwner {
        _disableWhitelist();
    }

    /**
     * Returns if an address is whitelisted.
     */
    function isWhitelisted(address _address) public view returns (bool) {
        return contractsWhiteList[_address];
    }
}
