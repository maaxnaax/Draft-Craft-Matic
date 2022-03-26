// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/finance/PaymentSplitter.sol";

/** 

    Contract to be deployed BEFORE UsePayments is deployed.  
    Payments contructor takes an array of withdrawee addresses to split payments across and an array of the proportions (% out of 100%) that 
        each withdrawee address is entitled to.
    Wallets at each of the addresses can then claim their proportion of the balance of this smart contracts Ether using Release() method. (Resp BNB)
    The second Release method accepts a token address and a withdrawee address, in order to distribute tokens other than Ether.
    Inheriting PaymentSplitter() means that we keep track of all transactions, so that withdrawees cannot claim more than they are owed.
    
*/

contract Payments is PaymentSplitter {
    
    constructor(address[] memory _payees, uint[] memory _shares) PaymentSplitter(_payees, _shares) payable {}
}

/**

EXAMPLE 1:

ADDRESSES:

    ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4",
    "0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2",
    "0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]

SPLIT:

    [20,
    70, 
    10]

*/ 



