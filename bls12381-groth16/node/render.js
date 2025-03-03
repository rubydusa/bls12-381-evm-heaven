const ejs = require('ejs');
const fs = require('fs');

const path = require('path');
const projectRoot = path.resolve(__dirname, '..');
const verifierTemplatePath = path.join(projectRoot, 'src', 'Groth16VerifierBLS12381.sol.ejs');
const verificationKeyPath = path.join(projectRoot, 'script', 'python', 'verification_key_processed.json');

const verificationKey = JSON.parse(
    fs.readFileSync(verificationKeyPath, 'utf8')
);
const template = fs.readFileSync(verifierTemplatePath, 'utf8');
const rendered = ejs.render(template, { vk: verificationKey });

fs.writeFileSync(path.join(projectRoot, 'src', 'Groth16VerifierBLS12381RESULT.sol'), rendered); 