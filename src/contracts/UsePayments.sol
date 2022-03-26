// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";


/** 

    Contract to be deployed AFTER Payments has been deployed.  
    Distribute takes the address of the deployed Payments in its contructor.

    This contract manages Payments, the payment splitting contract (Payments from Payments.sol).
    When this conrat is deployed, it takes the address of the deployed Payments.sol in the contructor. 
    This address can later be changed using the updatePaymentsAddress() method.
    Send Ether to this address using contribute() method.  The balance of this smart contracts address can then be withdrawn to the 
        Payments.sol contract to later be distributed. (Only the owner of this contract can use the withdraw() method)
    
*/

contract Distribute is Ownable {
    address payable public payments_contract;

    constructor(address _payments_contract) {
        payments_contract = payable(_payments_contract);
    }

    function updatePaymentsAddress(address payable newPaymentsAddress) public onlyOwner {
        payments_contract = payable(newPaymentsAddress);
    }

    function contribute() public payable {
        require(msg.value > 0.1 ether, "Please contribute a minimum of 0.1 ether.");
    }

    function getBalance() public view returns(uint _bal) {
        _bal = address(this).balance;
        return _bal;
    }

    function withdraw() public payable onlyOwner {
        (bool success, ) = payable(payments_contract).call{value: address(this).balance}("");
        require(success, "Withdraw failed.");
    }

}

