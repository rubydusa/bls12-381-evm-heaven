This file is a temporary mindmap so I won't forget some knowledge I gained during this development process.

My plans are:
- [ ] Implement BLS12381Lib.sol
- [ ] Learn PLONK/GROTH16 (whatever's easier) verification algorithm so I can implement a solidity verifier that uses BLS12381 curve parameters
- [ ] Write solidity verifier template in snarkjs fork

I thought modifiyng the plonk template would be simple enough since all logic is written down in the existing template,
but because it's all implemented in assembly and uses constants to access calldata, it'll be extremely tedious to refactor all the code
and moreover to identify bugs when they occur.
Not that implementing zk verifiers in solidity from scratch is not tedious, but writing it in proper solidity is much more readable and maintainable, and besides - I want to learn more about the verification algorithms anyway.

can't believe i'm actually committing this to this repo, but i'm too lazy to store it somewhere more organized.

---
12.2.2025
Writing to my ramble again
one day this file will be deleted from this repo (long before I make it public) but maybe someone will get curios about certain commit messages and visit this page

I'm very excited about the ability to validate consensus layer attestations on chain. This is crucial for EVM-lightclient implementation and I wonder if anyone else already implemented these standards.

I don't really care anymore about noir solidity verifier targets. Noir is already working on a verifier over BN254 with their UltraHonk and it's better to leave it to them (although it may be still smart to write ACIR>R1CS transpiling)
I'm though very excited about implementing a solidity Groth16 verifier template over BLS12381 because it means:
1. ZCash apps
2. Namada apps
3. Any other application that uses BLS12381

Many apps use BLS12381 on the protocol level because of its aggreagtion and implementing a Groth16 Solidity Verifier (sapling circuit for zcash is groth16) opens up a variety of applications