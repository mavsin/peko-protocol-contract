// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import "./Math.sol";

// pragma solidity >=0.5.0;

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint) external view returns (address pair);

    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

// pragma solidity >=0.5.0;

interface IUniswapV2Pair {
    event Approval(address indexed owner, address indexed spender, uint value);
    event Transfer(address indexed from, address indexed to, uint value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint);

    function balanceOf(address owner) external view returns (uint);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint value) external returns (bool);

    function transfer(address to, uint value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint);

    function permit(
        address owner,
        address spender,
        uint value,
        uint deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint amount0, uint amount1);
    event Burn(
        address indexed sender,
        uint amount0,
        uint amount1,
        address indexed to
    );
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

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint);

    function price1CumulativeLast() external view returns (uint);

    function kLast() external view returns (uint);

    function mint(address to) external returns (uint liquidity);

    function burn(address to) external returns (uint amount0, uint amount1);

    function swap(
        uint amount0Out,
        uint amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

// pragma solidity >=0.6.2;

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
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);

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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

    function swapExactETHForTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function swapTokensForExactETH(
        uint amountOut,
        uint amountInMax,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapExactTokensForETH(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external returns (uint[] memory amounts);

    function swapETHForExactTokens(
        uint amountOut,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable returns (uint[] memory amounts);

    function quote(
        uint amountA,
        uint reserveA,
        uint reserveB
    ) external pure returns (uint amountB);

    function getAmountOut(
        uint amountIn,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountOut);

    function getAmountIn(
        uint amountOut,
        uint reserveIn,
        uint reserveOut
    ) external pure returns (uint amountIn);

    function getAmountsOut(
        uint amountIn,
        address[] calldata path
    ) external view returns (uint[] memory amounts);

    function getAmountsIn(
        uint amountOut,
        address[] calldata path
    ) external view returns (uint[] memory amounts);
}

// pragma solidity >=0.6.2;

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
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
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

interface IWETHGateway {
    function depositETH(
        address lendingPool,
        address onBehalfOf,
        uint16 referralCode
    ) external payable;

    function withdrawETH(
        address lendingPool,
        uint256 amount,
        address onBehalfOf
    ) external;
}
//  -----------------------------------------------------------------------------------------------------------

contract Peko is ERC20Burnable, Ownable, Math {
    //  Variables for token --------------------------------------------------------------------
    using SafeMath for uint256;

    uint public constant INIT_TOTAL_SUPPLY = 1 * 1e8 * 1e18; //  100M tokens
    uint public constant SUPPLY_OF_ECOSYSTEM = 6 * 1e7 * 1e18; //  60M tokens
    uint public constant SUPPLY_LIMIT_OF_PRESALE = 1 * 1e7 * 1e18; //  10M tokens
    uint public constant SUPPLY_LIMIT_OF_PUBLIC_SALE = 3 * 1e7 * 1e18; //  30M tokens

    uint public supplyOfPresale = 0;
    uint public supplyOfPublicSale = 0;
    uint public tokenPrice;

    /* ---------------------------- Uniswap ------------------------------ */
    IUniswapV2Router02 public immutable uniswapV2Router;
    address public immutable uniswapV2Pair;
    /* ------------------------------------------------------------------- */

    /* ---------------------------- Wallets ------------------------------ */
    address public constant WALLET_OF_OWNER =
        0x2D6E7bA52EF8f899E578D9cfeF9218633AaDE8E7; //  OpenThink
    address public constant WALLET_OF_ECOSYSTEM =
        0xCc980A6aAE18bF99B289868ABDeC8d5DB094344e; //  Atskoi
    address public constant WALLET_OF_POOL =
        0xB9E3C5693f0B808f50410C4fd28ee7f2B88E1B18; //  Webfan
    address public walletOfFund = 0xCc980A6aAE18bF99B289868ABDeC8d5DB094344e; //  Atskoi
    /* ------------------------------------------------------------------- */

    bool public tradingEnabled;
    uint256 private launchedAt;
    mapping(address => bool) private _isExcludedFromFees;
    mapping(address => bool) private _isExcludedFromMaxTxLimit;
    mapping(address => bool) public automatedMarketMakerPairs;
    mapping(address => uint256) private usersCollateral;
    bytes32 public merkleRoot;
    bool public maxTransactionLimitEnabled = false;
    uint256 private maxTransactionRateBuy = 10; // 1%
    uint256 private maxTransactionRateSell = 10; // 1%
    uint256 public buyFee = 10; //  1%
    uint256 public sellFee = 10; //  1%
    bool public walletToWalletTransferWithoutFee = true;
    bool private swapping;
    uint256 public swappableTokenAmountAtOnce;

    event ExcludedFromMaxTransactionLimit(
        address indexed account,
        bool isExcluded
    );
    event ExcludeFromFees(address indexed account, bool isExcluded);
    event FeesUpdated(uint256 buyFee, uint256 sellFee);
    event SwapTokenAndSendEthToWallet(uint256 tokenAmount, uint256 ethAmount);
    event MaxTransactionLimitStateChanged(bool maxTransactionLimit);
    event WalletOfFundChanged(address marketingWallet);
    event MaxTransactionLimitRatesChanged(
        uint256 maxTransferRateBuy,
        uint256 maxTransferRateSell
    );
    event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
    event Withdraw(address toWallet);
    event SetMerkleRoot(bytes32 merkleRoot);
    event EnableWalletToWalletTransferWithoutFee(bool enable);
    event SetSwappableTokenAmountAtOnce(uint256 amount);
    event EnableTrading();
    event SetTokenPrice(uint256 _tokenPrice);

    //  Variables for lending   ----------------------------------------------------------------
    address[] public validAssets = [
        0xf56dc6695cF1f5c364eDEbC7Dc7077ac9B586068, //  USDC
        0x1990BC6dfe2ef605Bfc08f5A23564dB75642Ad73, //  USDT
        0x8741Ba6225A6BF91f9D73531A98A89807857a2B3, //  DAI
        0x7823E8DCC8bfc23EA3AC899EB86921f90e80F499, //  UNI
        0x6F03052743CD99ce1b29265E377e320CD24Eb632 //  HOP
    ];
    mapping(address => uint256) public totalDepositByAsset;
    mapping(address => uint256) public totalReserveByAsset;
    mapping(address => uint256) public totalBorrowedByAsset;
    mapping(address => mapping(address => uint256)) depositAmountOfAssetByUser;
    mapping(address => mapping(address => uint256)) borrowedAmountOfAssetByUser;
    uint256 public maxLTV = 4; // 1 = 20%
    uint256 public fixedAnnuBorrowRate = 300000000000000000;
    uint256 public baseRate = 20000000000000000;
    IERC20 public constant aWeth = IERC20(0x2c1b868d6596a18e32e61b901e4060c872647b6c);
    string private constant MSG_INVALID_ASSET = "Invalid asset.";

    constructor() ERC20("Peko Coin", "Peko") {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
            0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
        );
        uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
            .createPair(address(this), _uniswapV2Router.WETH());
        uniswapV2Router = _uniswapV2Router;

        _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);

        _approve(address(this), address(uniswapV2Router), INIT_TOTAL_SUPPLY);

        _isExcludedFromFees[owner()] = true;
        _isExcludedFromFees[WALLET_OF_OWNER] = true;
        _isExcludedFromFees[address(this)] = true;
        _isExcludedFromFees[WALLET_OF_ECOSYSTEM] = true;

        /* ---------- Share the tokens to the admin wallets -------- */
        _mint(WALLET_OF_ECOSYSTEM, SUPPLY_OF_ECOSYSTEM);
        _mint(WALLET_OF_OWNER, INIT_TOTAL_SUPPLY - SUPPLY_OF_ECOSYSTEM);
        /* ---------------------------------------------------------- */
    }

    function mint(address ownerWallet, uint amount) public onlyOwner {
        _mint(ownerWallet, amount * 1e18);
    }

    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        require(from != address(0), "ERC20: transfer from the zero address");
        require(to != address(0), "ERC20: transfer to the zero address");
        require(
            tradingEnabled ||
                _isExcludedFromFees[from] ||
                _isExcludedFromFees[to],
            "Trading is not enabled yet"
        );

        if (amount == 0) {
            super._transfer(from, to, 0);
            return;
        }

        if (maxTransactionLimitEnabled) {
            if (
                _isExcludedFromMaxTxLimit[from] == false &&
                _isExcludedFromMaxTxLimit[to] == false
            ) {
                if (from == uniswapV2Pair) {
                    require(
                        amount <= maxTransferAmountBuy(),
                        "AntiWhale: Transfer amount exceeds the maxTransferAmount"
                    );
                } else {
                    require(
                        amount <= maxTransferAmount(),
                        "AntiWhale: Transfer amount exceeds the maxTransferAmount"
                    );
                }
            }
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        bool canSwap = contractTokenBalance >= swappableTokenAmountAtOnce;

        if (canSwap && !swapping && automatedMarketMakerPairs[to]) {
            swapping = true;

            if (contractTokenBalance > swappableTokenAmountAtOnce * 10) {
                contractTokenBalance = swappableTokenAmountAtOnce * 10;
            }

            swapTokenAndSendEthToWallet(contractTokenBalance);

            swapping = false;
        }

        bool takeFee = !swapping;

        if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
            takeFee = false;
        }

        if (
            walletToWalletTransferWithoutFee &&
            from != uniswapV2Pair &&
            to != uniswapV2Pair
        ) {
            takeFee = false;
        }

        if (takeFee) {
            uint256 _totalFees;
            if (from == uniswapV2Pair) {
                _totalFees = buyFee;
            } else {
                _totalFees = sellFee;
            }
            uint256 fees = (amount * _totalFees) / 1000;

            amount = amount - fees;

            super._transfer(from, address(this), fees);
        }

        super._transfer(from, to, amount);
    }

    function _setAutomatedMarketMakerPair(address pair, bool value) private {
        automatedMarketMakerPairs[pair] = value;
        emit SetAutomatedMarketMakerPair(pair, value);
    }

    /**
        Check whether the account is contract or not.
     */
    function _isContract(address account) internal view returns (bool) {
        return account.code.length > 0;
    }

    /**
        Get max token amount that user can buy at once
     */
    function maxTransferAmountBuy() public view returns (uint) {
        return (totalSupply() * maxTransactionRateBuy) / 1000;
    }

    /**
        Get max token amount that can be transferred between ordinary users
     */
    function maxTransferAmount() public view returns (uint) {
        return (totalSupply() * maxTransactionRateSell) / 1000;
    }

    /**
        Enable or disable the limit of max transfer amount for a specified account.
     */
    function setExcludeFromMaxTransactionLimit(
        address account,
        bool exclude
    ) external onlyOwner {
        require(
            _isExcludedFromMaxTxLimit[account] != exclude,
            "Account is already set to that state"
        );
        _isExcludedFromMaxTxLimit[account] = exclude;
        emit ExcludedFromMaxTransactionLimit(account, exclude);
    }

    /**
        Exclude or include the account in paying fee
     */
    function excludeFromFees(
        address account,
        bool excluded
    ) external onlyOwner {
        require(
            _isExcludedFromFees[account] != excluded,
            "Account is already the value of 'excluded'"
        );
        _isExcludedFromFees[account] = excluded;

        emit ExcludeFromFees(account, excluded);
    }

    /**
        Check whether the account is excluded from paying fee or not.
     */
    function isExcludedFromFees(address account) public view returns (bool) {
        return _isExcludedFromFees[account];
    }

    /**
        Update the fees for buying and selling
     */
    function updateFees(uint256 _buyFee, uint256 _sellFee) external onlyOwner {
        require(
            _buyFee <= 20 && _sellFee <= 30,
            "Max buy fee is 2% and max sell fee is 3%."
        );
        buyFee = _buyFee;
        sellFee = _sellFee;
        emit FeesUpdated(buyFee, sellFee);
    }

    /**
        Swap token and send ethereum which are getting from swap to marketing wallet
     */
    function swapTokenAndSendEthToWallet(uint256 tokenAmount) private {
        uint256 initialBalance = address(this).balance;

        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0, // accept any amount of ETH
            path,
            address(this),
            block.timestamp
        );

        uint256 newBalance = address(this).balance - initialBalance;

        _sendETH(payable(walletOfFund), newBalance);

        emit SwapTokenAndSendEthToWallet(tokenAmount, newBalance);
    }

    /**
        Send ethereum to one of the admin wallets
     */
    function _sendETH(address payable recipient, uint256 amount) internal {
        require(
            address(this).balance >= amount,
            "Address: insufficient balance"
        );

        (bool success, ) = recipient.call{value: amount}("");
        require(
            success,
            "Address: unable to send value, recipient may have reverted"
        );
    }

    /**
        Enable trading of token
     */
    function enableTrading() external onlyOwner {
        require(launchedAt == 0, "Trading already enabled");
        launchedAt = block.timestamp;
        tradingEnabled = true;
        emit EnableTrading();
    }

    /**
        Set swappable token amount at once
     */
    function setSwappableTokenAmountAtOnce(
        uint256 newAmount
    ) external onlyOwner {
        require(
            newAmount > totalSupply() / 100000,
            "SwappableTokenAmountAtOnce must be greater than 0.001% of total supply"
        );
        swappableTokenAmountAtOnce = newAmount;
        emit SetSwappableTokenAmountAtOnce(newAmount);
    }

    /**
        Enable or disable the limit of max token amount can be traded at once
     */
    function setEnableMaxTransactionLimit(bool enable) external onlyOwner {
        require(
            enable != maxTransactionLimitEnabled,
            "Max transaction limit is already that state"
        );
        maxTransactionLimitEnabled = enable;
        emit MaxTransactionLimitStateChanged(maxTransactionLimitEnabled);
    }

    /**
        Enable or disable paying fee in the transferring token between 2 wallets
     */
    function enableWalletToWalletTransferWithoutFee(
        bool enable
    ) external onlyOwner {
        require(
            walletToWalletTransferWithoutFee != enable,
            "Wallet to wallet transfer without fee is already set to that value"
        );
        walletToWalletTransferWithoutFee = enable;
        emit EnableWalletToWalletTransferWithoutFee(enable);
    }

    /**
        Change the address of walletOfFund
     */
    function changeWalletOfFund(address _walletOfFund) external onlyOwner {
        require(
            walletOfFund != _walletOfFund,
            "Marketing wallet is already that address"
        );
        require(
            !_isContract(_walletOfFund),
            "Marketing wallet cannot be a contract"
        );
        walletOfFund = _walletOfFund;
        emit WalletOfFundChanged(walletOfFund);
    }

    /**
        Check whether the account is excluded from limitation of max token amount in one transaction
     */
    function isExcludedFromMaxTransaction(
        address account
    ) public view returns (bool) {
        return _isExcludedFromMaxTxLimit[account];
    }

    /**
        Percentage denoimator is 1000
     */
    function setMaxTransactionRates(
        uint256 _maxTransactionRateBuy,
        uint256 _maxTransactionRateSell
    ) external onlyOwner {
        require(
            _maxTransactionRateSell >= 1 && _maxTransactionRateBuy >= 1,
            "Max Transaction limit cannot be lower than 0.1% of total supply"
        );
        maxTransactionRateBuy = _maxTransactionRateBuy;
        maxTransactionRateSell = _maxTransactionRateSell;
        emit MaxTransactionLimitRatesChanged(
            maxTransactionRateBuy,
            maxTransactionRateSell
        );
    }

    /**
        Set the root of merkle tree of Partners' wallet addresses
     */
    function setMerkleRoot(bytes32 _merkleRoot) public onlyOwner {
        merkleRoot = _merkleRoot;
        emit SetMerkleRoot(_merkleRoot);
    }

    /**
      Private sale
    */
    function privateSale(uint amount) public payable {
        uint availableSupply = SUPPLY_LIMIT_OF_PRESALE - supplyOfPresale;
        uint newSupply = amount * 1e18;
        require(msg.value >= tokenPrice * amount, "Not Enough Funds");
        require(
            availableSupply > 0 && availableSupply >= newSupply,
            "The sale has been finished."
        );
        _transfer(WALLET_OF_OWNER, msg.sender, newSupply);
        supplyOfPresale += newSupply;
    }

    /**
        Public sale
     */
    function publicSale(uint amount) public payable {
        uint availableSupply = SUPPLY_LIMIT_OF_PUBLIC_SALE - supplyOfPublicSale;
        uint newSupply = amount * 1e18;
        require(msg.value >= tokenPrice * amount, "Not Enough Funds");
        require(
            availableSupply > 0 && availableSupply >= newSupply,
            "The sale has been finished."
        );
        _transfer(WALLET_OF_OWNER, msg.sender, newSupply);
        supplyOfPublicSale += newSupply;
    }

    function setTokenPrice(uint _tokenPrice) public onlyOwner {
        tokenPrice = _tokenPrice;
        emit SetTokenPrice(_tokenPrice);
    }

    function withdraw(address ownerWallet) public onlyOwner {
        require(ownerWallet != address(0), "Invalid wallet address");
        Address.sendValue(payable(ownerWallet), address(this).balance);
        emit Withdraw(ownerWallet);
    }

    /** Check an asset is a valid deposit one. */
    function _validateAsset(address _asset) internal view returns (bool) {
        for (uint8 i = 0; i < validAssets.length; i += 1) {
            if (_asset == validAssets[i]) {
                return true;
            }
        }
        return false;
    }

    function depositAsset(address asset, uint amount) external {
        require(_validateAsset(asset) == true, MSG_INVALID_ASSET);
        IERC20(asset).transferFrom(msg.sender, WALLET_OF_POOL, amount);
        totalDepositByAsset[asset] += amount;
        uint bondsToMint = getExp(amount, getExchangeRate(asset));
        // _transfer(WALLET_OF_ECOSYSTEM, msg.sender, bondsToMint);
        burnFrom(WALLET_OF_ECOSYSTEM, bondsToMint);
        _mint(msg.sender, bondsToMint);
    }

    function withdrawAsset(address asset, uint amount) external {
        require(_validateAsset(asset) == true, MSG_INVALID_ASSET);
        require(amount <= balanceOf(msg.sender), "Not enough bonds!");
        uint256 daiToReceive = mulExp(amount, getExchangeRate(asset));
        totalDepositByAsset[asset] -= daiToReceive;
        IERC20(asset).transferFrom(WALLET_OF_ECOSYSTEM, msg.sender, amount);
        // _transfer(msg.sender, WALLET_OF_ECOSYSTEM, daiToReceive);
        burnFrom(msg.sender, daiToReceive);
        _mint(WALLET_OF_ECOSYSTEM, daiToReceive);
    }

    function borrow(address asset, uint256 amount) external {
        require(_validateAsset(asset) == true, "Invalid asset.");
        require(amount <= _borrowLimit(asset), "No collateral enough");
        borrowedAmountOfAssetByUser[msg.sender][asset] += amount;
        totalBorrowedByAsset[asset] += amount;
        IERC20(asset).transferFrom(WALLET_OF_ECOSYSTEM, msg.sender, amount);
    }

    function repay(address asset, uint256 amount) external {
        require(_validateAsset(asset) == true, "Invalid asset.");
        require(
            borrowedAmountOfAssetByUser[msg.sender][asset] > 0,
            "Doesnt have a debt to pay"
        );
        IERC20(asset).transferFrom(msg.sender, WALLET_OF_ECOSYSTEM, amount);
        (uint256 fee, uint256 paid) = calculateBorrowFee(asset, amount);
        borrowedAmountOfAssetByUser[msg.sender][asset] -= paid;
        totalBorrowedByAsset[asset] -= paid;
        totalReserveByAsset[asset] += fee;
    }

    // function liquidation(address user, address asset) external onlyOwner {
    //     require(_validateAsset(asset) == true, "Invalid asset.");
    //     uint256 wethPrice = uint256(_getLatestPrice());
    //     uint256 collateral = usersCollateral[user];
    //     uint256 borrowed = borrowedAmountOfAssetByUser[user][asset];
    //     uint256 collateralToUsd = mulExp(wethPrice, collateral);
    //     if (borrowed > percentage(collateralToUsd, maxLTV)) {
    //         _withdrawWethFromAave(collateral);
    //         uint256 amountAsset = _convertEthToAsset(asset, collateral);
    //         if (amountAsset > borrowed) {
    //             uint256 extraAmount = amountAsset.sub(borrowed);
    //             totalReserveByAssetAddress[asset] += extraAmount;
    //         }
    //         _sendAssetToAave(IERC20(asset), amountAsset);
    //         borrowedByUserAddress[user][asset] = 0;
    //         usersCollateral[user] = 0;
    //         totalCollateral -= collateral;
    //     }
    // }

    function calculateBorrowFee(
        address asset,
        uint256 amount
    ) public view returns (uint256, uint256) {
        require(_validateAsset(asset) == true, "Invalid asset.");
        uint256 borrowRate = _borrowRate(asset);
        uint256 fee = mulExp(amount, borrowRate);
        uint256 paid = amount.sub(fee);
        return (fee, paid);
    }

    function getExchangeRate(address asset) public view returns (uint256) {
        require(_validateAsset(asset) == true, MSG_INVALID_ASSET);
        if (totalSupply() == 0) {
            return 1000000000000000000;
        }
        uint256 cash = getCash(asset);
        uint256 num = cash.add(totalBorrowedByAsset[asset]).add(
            totalReserveByAsset[asset]
        );
        return getExp(num, totalSupply());
    }

    function getCash(address asset) public view returns (uint256) {
        require(_validateAsset(asset) == true, MSG_INVALID_ASSET);
        return totalDepositByAsset[asset].sub(totalBorrowedByAsset[asset]);
    }

    function _borrowLimit(address asset) public view returns (uint256) {
        require(_validateAsset(asset) == true, "Invalid asset.");
        uint256 amountLocked = usersCollateral[msg.sender];
        require(amountLocked > 0, "No collateral found");
        uint256 amountBorrowed = borrowedAmountOfAssetByUser[msg.sender][asset];
        uint256 wethPrice = uint256(_getLatestPrice());
        uint256 amountLeft = mulExp(amountLocked, wethPrice).sub(
            amountBorrowed
        );
        return percentage(amountLeft, maxLTV);
    }

    function _utilizationRatio(address asset) public view returns (uint256) {
        require(_validateAsset(asset) == true, "Invalid asset.");
        return getExp(totalBorrowedByAsset[asset], totalDepositByAsset[asset]);
    }

    function _getLatestPrice() public view returns (int256) {
        // (, int256 price, , , ) = priceFeed.latestRoundData();
        return 1 * 10 ** 10;
    }

    function _interestMultiplier(address asset) public view returns (uint256) {
        require(_validateAsset(asset) == true, MSG_INVALID_ASSET);
        uint256 uRatio = _utilizationRatio(asset);
        uint256 num = fixedAnnuBorrowRate.sub(baseRate);
        return getExp(num, uRatio);
    }

    function _borrowRate(address asset) public view returns (uint256) {
        require(_validateAsset(asset) == true, MSG_INVALID_ASSET);
        uint256 uRatio = _utilizationRatio(asset);
        uint256 interestMul = _interestMultiplier(asset);
        uint256 product = mulExp(uRatio, interestMul);
        return product.add(baseRate);
    }

    //  fallback to recieve ether in
    receive() external payable {}
}
