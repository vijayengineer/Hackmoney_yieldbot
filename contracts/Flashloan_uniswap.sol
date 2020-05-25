pragma solidity ^0.6.6;

import "./aave/FlashLoanReceiverBase.sol";
import "./aave/ILendingPoolAddressesProvider.sol";
import "./aave/ILendingPool.sol";
import './IUniswapV2Router01.sol';

contract Flashloan_uniswap is FlashLoanReceiverBase {

         address internal constant UNISWAP_ROUTER_ADDRESS = 0xf164fC0Ec4E93095b804a4795bBe1e041497b92a; // Ropsten
         IUniswapV2Router01 public uniswapRouter;

         constructor(address _addressProvider) FlashLoanReceiverBase(_addressProvider) public {}

    /**
        This function is called after your contract has received the flash loaned amount
     */
    function executeOperation(
        address _reserve,
        uint256 _amount,
        uint256 _fee,
        bytes calldata _params
    )
        external
        override
    {
        require(_amount <= getBalanceInternal(address(this), _reserve), "Invalid balance, was the flashLoan successful?");

        //
        // Your logic goes here.
        // !! Ensure that *this contract* has enough of `_reserve` funds to payback the `_fee` !!
        //
           // Build arguments for uniswap router call
          
        uint ethAmount = 1;
        
        require(ethAmount <= address(this).balance, "Not enough Eth in contract to perform swap.");
        address[] memory path = new address[](2);
        address tokenAddress = 0x2b591e99afE9f32eAA6214f7B7629768c40Eeb39;
        path[0] = uniswapRouter.WETH();
        path[1] = tokenAddress;
        uniswapRouter.swapExactETHForTokens(ethAmount, path,address(this) , now + 15);

        uint totalDebt = _amount.add(_fee);
        transferFundsBackToPoolInternal(_reserve, totalDebt);
    }

    /**
        Flash loan 1000000000000000000 wei (1 ether) worth of `_asset`
     */
    function flashloan(address _asset) public onlyOwner {
        bytes memory data = "";
        uint amount = 1 ether;

        ILendingPool lendingPool = ILendingPool(addressesProvider.getLendingPool());
        lendingPool.flashLoan(address(this), _asset, amount, data);
    }
}
