const ejs = require('ejs');
const fs = require('fs');
const path = require('path');

const projectRoot = path.resolve(__dirname);
const verifierTemplatePath = path.join(projectRoot, 'Groth16VerifierBLS12381.sol.ejs');
if (process.argv.length !== 4) {
    console.error('Usage: node render.js <verification_key_path> <output_solidity_path>');
    process.exit(1);
}
const verificationKeyPath = process.argv[2];
const outputSolidityPath = process.argv[3];

const verificationKey = JSON.parse(
    fs.readFileSync(verificationKeyPath, 'utf8')
);
const template = fs.readFileSync(verifierTemplatePath, 'utf8');
const rendered = ejs.render(template, { vk: verificationKey });

fs.writeFileSync(outputSolidityPath, rendered); 