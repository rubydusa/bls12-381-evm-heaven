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
