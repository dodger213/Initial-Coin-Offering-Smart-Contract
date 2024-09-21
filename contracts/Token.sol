//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./ERC20.sol";
import "./Ownable.sol";
import "./Pausable.sol";

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);
    function symbol() external pure returns (string memory);
    function decimals() external pure returns (uint8);
    function totalSupply() external view returns (uint);
    function balanceOf(address owner) external view returns (uint);
    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);
    function transfer(address to, uint value) external returns (bool);
    function transferFrom(address from, address to, uint value) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);
    function PERMIT_TYPEHASH() external pure returns (bytes32);
    function nonces(address owner) external view returns (uint);

    function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
    event Swap(
        address indexed sender,
        uint amount0In,
        uint amount1In,
        uint amount0Out,
        uint amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint);
    function factory() external view returns (address);
    function token0() external view returns (address);
    function token1() external view returns (address);
    function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
    function price0CumulativeLast() external view returns (uint);
    function price1CumulativeLast() external view returns (uint);
    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);
    function burn(address to) external returns (uint amount0, uint amount1);
    function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
    function skim(address to) external;
    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Factory {
    event PairCreated(address indexed token0, address indexed token1, address pair, uint);

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(address tokenA, address tokenB) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(address tokenA, address tokenB) external returns (address pair);

    function setFeeTo(address) external;
    function setFeeToSetter(address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);
    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountA, uint amountB);
    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountToken, uint amountETH);
    function swapExactTokensForTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapTokensForExactTokens(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);
    function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);
    function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
        external
        returns (uint[] memory amounts);
    function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
        external
        payable
        returns (uint[] memory amounts);

    function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
    function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
    function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
    function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
    function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountETH);
    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax, uint8 v, bytes32 r, bytes32 s
    ) external returns (uint amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;
}

/**
 * @author Roberto Agüera
 * @title  ERC20 Token smart contract
 * @notice Smart contract to create and manage ERC20 Token. It can swap BNB for TKN.
 *         It allows the owner to pause tokens transfers if necessary.
 *         Once the owner receives funds from the presale contract, call addLiquidityToPS() to add BNBs and TKNs liquidity to PancakeSwap.
 *
 * How it works:
 *
 * - Presale smart contract must be deployed (by passing ERC20 Token smart contract address in the constructor) right after
 *   this contract is deployed. It is done automatically with Truffle.
 */

contract MyToken is ERC20, Ownable, Pausable {

    // CONFIG START

    uint256 private denominator = 100;

    uint256 private swapThreshold = 0.0000005 ether; // The contract will only swap to ETH, once the fee tokens reach the specified threshold

    uint256 private devTaxBuy;
    uint256 private marketingTaxBuy;
    uint256 private liquidityTaxBuy;
    uint256 private administrationTaxBuy;
    
    uint256 private devTaxSell;
    uint256 private marketingTaxSell;
    uint256 private liquidityTaxSell;
    uint256 private administrationTaxSell;
    
    /**
     * @dev Wallets where taxes should be paid. Replace them for you own addresses
     */
    address private devTaxWallet = address(0);
    address private marketingTaxWallet = address(0);
    address private administrationTaxWallet = address(0);
    address private liquidityTaxWallet = address(0);

    /**
     * @dev This is the only wallet that cannot be changed once it is deployed. This is the wallet you use to retrieve liquidity from PancakeSwap.
     * This is the same address as the presaleLiquidityWallet on TokenPresale.sol
     */
    address private presaleLiquidityWallet = address(0);

    /**
     * @dev PancakeSwap Router address for testnet (check it out here: https://amm.kiemtienonline360.com/). For mainnet, use 0x10ED43C718714eb63d5aA57B78B54704E256024E
     */
    address private pancakeSwapLiquidityAddress = 0x9Ac64Cc6e4415144C455BD8E4837Fea55603e5c3;

    uint256 private devTokens;
    uint256 private marketingTokens;
    uint256 private administrationTokens;
    uint256 private liquidityTokens;

    uint256 private lockEndsDate = 548 days; // Lock time is 1 year and a half
    uint256 public lockDate;

    address private presaleContractAddress;

    mapping(address => uint256) private lockedBalances;

    mapping(uint8 => address) public managers;

    mapping(address => bool) private excludeList;

    mapping(string => uint256) private buyTaxes;
    mapping(string => uint256) private sellTaxes;
    mapping(string => address) private taxWallets;
    
    bool public taxStatus = true;

    bool private approvePresaleContractIsAllowed = true;
    
    IUniswapV2Router02 private uniswapV2Router02;
    IUniswapV2Factory private uniswapV2Factory;
    IUniswapV2Pair private uniswapV2Pair;

    event Log(string, uint);

    modifier isManager() {
        require(managers[0] == msg.sender || managers[1] == msg.sender || managers[2] == msg.sender, "Not manager");
        _;
    }

    //CONFIG END

    constructor () payable ERC20("MyToken", "TKN") {
        mint(msg.sender, 100000000000 * (10 ** uint256(decimals())));

        _transferOwnership(msg.sender);

        uniswapV2Router02 = IUniswapV2Router02(pancakeSwapLiquidityAddress);
        uniswapV2Factory = IUniswapV2Factory(uniswapV2Router02.factory());
        uniswapV2Pair = IUniswapV2Pair(uniswapV2Factory.createPair(address(this), uniswapV2Router02.WETH()));

        managers[0] = msg.sender;
        managers[1] = devTaxWallet;
        managers[2] = administrationTaxWallet;

        taxWallets["liquidity"] = liquidityTaxWallet;
        taxWallets["dev"] = devTaxWallet;
        taxWallets["marketing"] = marketingTaxWallet;
        taxWallets["administration"] = administrationTaxWallet;
        setBuyTax(1, 1, 1, 1);
        setSellTax(1, 1, 1, 1);
        setTaxWallets(taxWallets["dev"], taxWallets["marketing"], taxWallets["liquidity"], taxWallets["administration"]);

        exclude(msg.sender);
        exclude(address(this));

        lockDate = block.timestamp + lockEndsDate; // Date when BNBs will be unlocked for the owner
    }

    function mint(address _to, uint256 _amount) private onlyOwner {
        _mint(_to, _amount);
    }

    function burn(uint256 _value) public returns (address) {
        _burn(_msgSender(), _value);
        return _msgSender();
    }

    /**
     * @dev Calculates the tax, transfer it to the contract. If the user is selling, and the swap threshold is met, it executes the tax.
     */
    function handleTax(address from, address to, uint256 amount) private returns (uint256) {
        address[] memory sellPath = new address[](2);
        sellPath[0] = address(this);
        sellPath[1] = uniswapV2Router02.WETH();
        
        if(!isExcluded(from) && !isExcluded(to)) {
            uint256 tax;
            uint256 baseUnit = amount / denominator;
            if(from == address(uniswapV2Pair)) {
                tax += baseUnit * buyTaxes["marketing"];
                tax += baseUnit * buyTaxes["dev"];
                tax += baseUnit * buyTaxes["liquidity"];
                tax += baseUnit * buyTaxes["administration"];
                
                if(tax > 0) {
                    _transfer(from, address(this), tax);   
                }
                
                marketingTokens += baseUnit * buyTaxes["marketing"];
                devTokens += baseUnit * buyTaxes["dev"];
                liquidityTokens += baseUnit * buyTaxes["liquidity"];
                administrationTokens += baseUnit * buyTaxes["administration"];
            } else if(to == address(uniswapV2Pair)) {
                tax += baseUnit * sellTaxes["marketing"];
                tax += baseUnit * sellTaxes["dev"];
                tax += baseUnit * sellTaxes["liquidity"];
                tax += baseUnit * sellTaxes["administration"];
                
                if(tax > 0) {
                    _transfer(from, address(this), tax);   
                }
                
                marketingTokens += baseUnit * sellTaxes["marketing"];
                devTokens += baseUnit * sellTaxes["dev"];
                liquidityTokens += baseUnit * sellTaxes["liquidity"];
                administrationTokens += baseUnit * sellTaxes["administration"];
                
                uint256 taxSum = marketingTokens + devTokens + liquidityTokens + administrationTokens;
                
                if(taxSum == 0) return amount;
                
                uint256 ethValue = uniswapV2Router02.getAmountsOut(marketingTokens + devTokens + liquidityTokens + administrationTokens, sellPath)[1];
                
                if(ethValue >= swapThreshold) {
                    uint256 startBalance = address(this).balance;

                    uint256 toSell = marketingTokens + devTokens + liquidityTokens / 2 + administrationTokens;
                    
                    _approve(address(this), address(uniswapV2Router02), toSell);
            
                    uniswapV2Router02.swapExactTokensForETH(
                        toSell,
                        0,
                        sellPath,
                        address(this),
                        block.timestamp
                    );
                    
                    uint256 ethGained = address(this).balance - startBalance;
                    
                    uint256 liquidityToken = liquidityTokens / 2;
                    uint256 liquidityETH = (ethGained * ((liquidityTokens / 2 * 10**18) / taxSum)) / 10**18;
                    
                    uint256 marketingETH = (ethGained * ((marketingTokens * 10**18) / taxSum)) / 10**18;
                    uint256 devETH = (ethGained * ((devTokens * 10**18) / taxSum)) / 10**18;
                    uint256 administrationETH = (ethGained * ((administrationTokens * 10**18) / taxSum)) / 10**18;
                    
                    _approve(address(this), address(uniswapV2Router02), liquidityToken);
                    
                    (uint amountToken, ,) = uniswapV2Router02.addLiquidityETH{value: liquidityETH}(
                        address(this),
                        liquidityToken,
                        0,
                        0,
                        owner(),
                        block.timestamp
                    );
                    
                    uint256 remainingTokens = (marketingTokens + devTokens + liquidityTokens + administrationTokens) - (toSell + amountToken);
                    
                    if(remainingTokens > 0) {
                        _transfer(address(this), owner(), remainingTokens);
                    }
                    
                    (bool success,) = taxWallets["marketing"].call{value: marketingETH}("");
                    (bool success1,) = taxWallets["dev"].call{value: devETH}("");
                    (bool success2,) = taxWallets["administration"].call{value: administrationETH}("");
                    require(success && success1 && success2, "Transfer rejected");
                    
                    if(ethGained - (marketingETH + devETH + liquidityETH + administrationETH) > 0) {
                        uint _amt = ethGained - (marketingETH + devETH + liquidityETH + administrationETH);
                        (bool success3,) = taxWallets["marketing"].call{value: _amt}("");
                        require(success3, "Transfer rejected");
                    }
                    
                    marketingTokens = 0;
                    devTokens = 0;
                    liquidityTokens = 0;
                    administrationTokens = 0;
                }
                
            }
            
            amount -= tax;
        }
        
        return amount;
    }

    /**
     * @dev Triggers the tax handling functionality
     */
    function triggerTax() public onlyOwner {
        handleTax(address(0), address(uniswapV2Pair), 0);
    }

    /**
     * @dev Adds presale ICO funds to PancakeSwap liquidity
     */
    function addLiquidityToPS(uint256 amountToken) external payable onlyOwner {
        _approve(address(this), address(uniswapV2Router02), amountToken);
                    
        (uint _amountToken, uint _amountETH, uint _liquidity) = uniswapV2Router02.addLiquidityETH{value: msg.value}(
            address(this),
            amountToken,
            0,
            0,
            presaleLiquidityWallet,
            block.timestamp+10000
        );
        emit Log("amountToken", _amountToken);
        emit Log("amountETH", _amountETH);
        emit Log("liquidity", _liquidity);
    }

    function pause() public isManager {
        _pause();
    }

    function unpause() public isManager {
        _unpause();
    }

    function balance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Unlocks initial liquidity withdraw if date has been reached
     */
    function unlockTokens(address _address) public {
        require(block.timestamp > lockDate, "Unlock date not reached yet");
        lockedBalances[_address] = 0;
    }

    /**
     * @dev Sets presale contract address. It is called automatically right after presale contract is deployed.
     */
    function setPresaleContractAddress() external override returns (address) {
        require(presaleContractAddress == address(0), "Address already initialized");
        presaleContractAddress = msg.sender;
        return presaleContractAddress;
    }

    /**
     * @dev Approves presale contract to transfer initial tokens on your behalf
     */
    function approvePresaleContract(uint256 _amount) external override returns (bool) {
        require(approvePresaleContractIsAllowed, "Approval to presale contract is not allowed anymore");
        require(msg.sender == getPresaleContractAddress(), "You are not allowed to call this function");
        _approve(owner(), getPresaleContractAddress(), _amount);
        approvePresaleContractIsAllowed = false;
        return true;
    }

    function getPresaleContractAddress() public view returns (address) {
        return presaleContractAddress;
    }

    function getLockedBalance(address _address) public view returns (uint256) {
        return lockedBalances[_address];
    }

    function setLockedBalance(address _address, uint256 _lockedBalance) external override returns (bool) {
        require(msg.sender == getPresaleContractAddress(), "You are not allowed to call this function");
        lockedBalances[_address] = _lockedBalance;
        return true;
    }

    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal override whenNotPaused virtual {
        if(recipient == presaleLiquidityWallet && getLockedBalance(presaleLiquidityWallet) > 0){
            require(amount <= (balanceOf(presaleLiquidityWallet) - getLockedBalance(presaleLiquidityWallet)), "This recipient address is not allowed to do this transfer");
        }

        if(taxStatus) {
            amount = handleTax(sender, recipient, amount);
        }
        
        super._transfer(sender, recipient, amount);
    }

    function transfer(address _to, uint256 _amount) public virtual override returns (bool) {
        _transfer(_msgSender(), _to, _amount);
        return true;
    }

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public virtual override returns (bool) {
        _spendAllowance(from, _msgSender(), amount);
        _transfer(from, to, amount);
        return true;
    }

    receive() external payable {}

    /**
     * @dev Sets tax for buys.
     */
    function setBuyTax(uint256 _dev, uint256 _marketing, uint256 _liquidity, uint256 _administration) public onlyOwner {
        buyTaxes["dev"] = _dev;
        buyTaxes["marketing"] = _marketing;
        buyTaxes["liquidity"] = _liquidity;
        buyTaxes["administration"] = _administration;
    }
    
    /**
     * @dev Sets tax for sells.
     */
    function setSellTax(uint256 _dev, uint256 _marketing, uint256 _liquidity, uint256 _administration) public onlyOwner {
        sellTaxes["dev"] = _dev;
        sellTaxes["marketing"] = _marketing;
        sellTaxes["liquidity"] = _liquidity;
        sellTaxes["administration"] = _administration;
    }

    /**
     * @dev Sets wallets for taxes.
     */
    function setTaxWallets(address _dev, address _marketing, address _liquidity, address _administration) public onlyOwner {
        taxWallets["dev"] = _dev;
        taxWallets["marketing"] = _marketing;
        taxWallets["liquidity"] = _liquidity;
        taxWallets["administration"] = _administration;
    }
    
    /**
     * @dev Enables tax globally.
     */
    function enableTax() public onlyOwner {
        require(!taxStatus, "Tax is already enabled");
        taxStatus = true;
    }
    
    /**
     * @dev Disables tax globally.
     */
    function disableTax() public onlyOwner {
        require(taxStatus, "Tax is already disabled");
        taxStatus = false;
    }

    /**
     * @dev Excludes the specified account from tax.
     */
    function exclude(address _account) public onlyOwner {
        require(!isExcluded(_account), "Account is already excluded");
        excludeList[_account] = true;
    }

    /**
     * @dev Re-enables tax on the specified account.
     */
    function removeExclude(address _account) public onlyOwner {
        require(isExcluded(_account), "Account is not excluded");
        excludeList[_account] = false;
    }

    /**
     * @dev Returns true if the account is excluded, and false otherwise.
     */
    function isExcluded(address _account) public view returns (bool) {
        return excludeList[_account];
    }

    /**
     * @dev allows to change managers.
     */
    function changeManager(address _manager, uint8 _index) public isManager {
        require(_index >= 0 && _index <= 2, "Invalid index");
        managers[_index] = _manager;
    }
}
