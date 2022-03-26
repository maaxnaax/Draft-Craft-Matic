// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/** 
  Testing VRF v1.0
*/

import './VRFConsumerBase.sol';
// import "https://raw.githubusercontent.com/smartcontractkit/chainlink-brownie-contracts/main/contracts/src/v0.8/VRFConsumerBase.sol";
// import {SafeMath} from "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract RandomNumbersConsumer is VRFConsumerBase {
    // using SafeMath for uint256;
    
    bytes32 public keyHash;
    uint public fee;
    uint public randomResult;

    constructor() VRFConsumerBase(0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, 0x01BE23585060835E02B77ef475b0Cc51aA1e0709
        ) public 
    {   
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18;
    }

    function getRandomNumber() public returns(bytes32 requestId) {
        return requestRandomness(keyHash, fee);
        // fulfillRandomness(requestId, randomness);
    }

    function fulfillRandomness(bytes32 requestId, uint randomness) internal override {
        randomResult = randomness % 20 + 1;
    }

}
