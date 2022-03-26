# Draft-Craft-Matic
A fantasy Football draft game, with a crypto prize pool and distribution mechanics.  Similar to FIFA Fut Draft (https://www.futbin.com/draft-simulator), but instead minting TEAM NFTs which are tied to the real world performance of players on a per tournament basis.

Order of Operations for Deployment:
1. In MetaMask, switch to desired network (BSC Mainnet, BSC Testnet, Eth mainnet, Rinkeby)
2. Create a subscription on https://vrf.chain.link/chapel, and record subscription id (id = 188 for current deployment on BSC Testnet).
3. Fund the subscription with Link Token.
4. In VRFMintTeam.sol, adjust variables: link, vrfCoordinator and keyHash, to match: Link Token Address, VRF Coordinator address and Key hash, for the chosen network on https://vrf.chain.link/chapel.
5. Deploy VRFMintTeam.sol with id (from step 2) as constructor arg. Record address.
6. Register address (from step 5) on https://vrf.chain.link/chapel/ + id by clicking add consumer and filling in the details.

Fucntionality:
- VRFMintTeam.sol is to be accessed using js frontend.  One can generate a random list of candidate football players using VRF, then select a subset to be minted and mint the team.  80% of minting cost goes to a prize pool called Pot.
- UsePayments.sol fills the pot.
- Withdrawing using Payments contract in Payments.sol makes use of the safe withdrawl pattern from Openzeppelin, to prevent re-entrancy attacks on withdrawls.
- Payments.sol distributes pot to users who have won.

TODO:
- Make method so that UsePayemts contract can deploy an instance of Payments with pot distributions arrays once winners have been confirmed.
- Use nonReentrant modifier on all mint related functions. https://docs.openzeppelin.com/contracts/4.x/api/security
- Multisig for upgrades https://docs.openzeppelin.com/defender/guide-upgrades
