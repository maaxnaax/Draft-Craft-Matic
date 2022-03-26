// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

// Chainlink VRF imports:
import "@chainlink/contracts/src/v0.8/interfaces/LinkTokenInterface.sol";
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

contract MyToken is ERC721, ERC721Enumerable, ERC721URIStorage, VRFConsumerBaseV2, Ownable {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIdCounter;

    // VRF params: ----------------------------------------------------------

    VRFCoordinatorV2Interface COORDINATOR;
    LinkTokenInterface LINKTOKEN;

    uint64 s_subscriptionId;
    address vrfCoordinator = 0x6A2AAd07396B36Fe02a22b33cf443582f682c82f;
    address link = 0x84b9B910527Ad5C03A9Ca831909E21e236EA7b06;
    bytes32 keyHash = 0xd4bb89654db74673a187bd804519e65e3f71a52bc55f11da7601a13dcf505314;
    uint32 callbackGasLimit = 100000;
    uint16 requestConfirmations = 3;
    uint32 numWords =  7;
    uint32 totalPlayers =  7;
    uint32 teamSize =  7;
    uint32 MPrice =  1; //  in wei

    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;
    bool public randomTWorked = false;

    mapping(uint256 => mapping(uint => bool)) public nestReqIdToPlyrMap;
    mapping(uint => address) public mapReqIdToOwner;

    // End of VRF params ----------------------------------------------------

    // constructor() ERC721("MintTEAM", "DCTEAM")  {}

    constructor(uint64 subscriptionId)  ERC721("MintTEAM", "DCTEAM")  VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        LINKTOKEN = LinkTokenInterface(link);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    // VRF Functions: -------------------------------------------------------
    
    
    // Assumes the subscription is funded sufficiently.
    function requestRandomWords() external {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
        keyHash,
        s_subscriptionId,
        requestConfirmations,
        callbackGasLimit,
        numWords
        );
        mapReqIdToOwner[s_requestId] = msg.sender;
    }
    
    function fulfillRandomWords(
        uint256 _requestId, /* requestId */
        // uint256 /* requestId */
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;

        for (uint i=0; i<numWords; i++) {
            nestReqIdToPlyrMap[_requestId][randomWords[i] % totalPlayers] = true;
            // nestReqIdToPlyrMap[_requestId][uint(keccak256(abi.encodePacked(_requestId, randomWords[i] % totalPlayers)))] = true;
        }
        // emit fulfillFilled(_requestId, randomWords, msg.sender);
    }
    
    // End of VRF Functions: ------------------------------------------------

    // ======= TEMP FUNCTION FOR TESTING: =======

    function testingMintT() public {

        // uint _requestId = 0;
        mapReqIdToOwner[0] = msg.sender;
        nestReqIdToPlyrMap[0][0] = true;
        nestReqIdToPlyrMap[0][1] = true;
        nestReqIdToPlyrMap[0][2] = true;
        nestReqIdToPlyrMap[0][3] = true;
        nestReqIdToPlyrMap[0][4] = true;
        nestReqIdToPlyrMap[0][5] = true;
        nestReqIdToPlyrMap[0][6] = true;

    }


    // ==========================================

    // Making a string from a uint 

    function uint2str(uint _i) internal pure returns (string memory _uintAsString) {
        if (_i == 0) {
            return "0";
        }
        uint j = _i;
        uint len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        uint k = len;
        while (_i != 0) {
            k = k-1;
            uint8 temp = (48 + uint8(_i - _i / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _i /= 10;
        }
        return string(bstr);
    }

    // Concatenating strings:
    function concatSeven(string memory a, string memory b, string memory c, string memory d, string memory e, string memory f, string memory g) 
        internal pure returns (string memory) {
            return string(abi.encodePacked(a, b, c, d, e, f, g));
        }

    // Concatenating strings:
    function concatTwo(string memory a, string memory b) 
        internal pure returns (string memory) {
            return string(abi.encodePacked(a, b));
        }


    function ownsTeam(uint256 _requestId, uint[] memory _players) public view returns (bool _boo) {
        _boo = true;
        for (uint256 i = 0; i < teamSize; i++) {
            // if(!nestReqIdToPlyrMap[_requestId][uint(keccak256(abi.encodePacked(_requestId, _players[i] % totalPlayers)))]) {
            if(!nestReqIdToPlyrMap[_requestId][_players[i]]) {
                _boo = false;
            }
        }
        return _boo;
    }
    
    function MintT(uint[] memory _plyrs, uint _requestId) public payable {

        // Need to still check that 
        require(_plyrs.length == teamSize, "Select a player from each slot");
        require(mapReqIdToOwner[_requestId] == msg.sender, "You need to generate a random team, select players, and then mint");
        require(msg.value >= MPrice, "It costs 170 USD to mint a team");
        // Check that the team is owned by the 
        require(ownsTeam(_requestId, _plyrs), "You did not generate the team tht you are currently trying to");
        string memory _uri1 = concatSeven("Captain: ", uint2str(_plyrs[0]), ", Forward: ", uint2str(_plyrs[1]), "Forward: ", uint2str(_plyrs[2]), "Forward: ");
        string memory _uri2 = concatSeven(uint2str(_plyrs[3]), "Back: ", uint2str(_plyrs[4]), "Back: ", uint2str(_plyrs[5]), "Back: ", uint2str(_plyrs[6]) );
        // string memory _uri = "randomTeam";
        string memory _uri = concatTwo(_uri1, _uri2);
        safeMint(msg.sender, _uri);

    }


    // FROM OPENZEPPELIN:

    function safeMint(address to, string memory uri) private {
        uint256 tokenId = _tokenIdCounter.current();
        _tokenIdCounter.increment();
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function changeNumWords(uint32 _num) public {
        numWords = _num;
    }

    function changetotalPlayers(uint32 _num) public {
        totalPlayers = _num;
    }

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address from, address to, uint256 tokenId)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId) internal override(ERC721, ERC721URIStorage) {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
    // My events:
    event fulfillFilled(uint _requestId, uint[] _randomWords, address);
}


// https://github.com/simontianx/OnChainRNG/blob/main/GaussianRNG/contracts/GaussianRNG.sol  - Could use this to make GAUSSIAN dist.  Might be expensive
