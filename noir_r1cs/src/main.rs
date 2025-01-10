//use acir_field::GenericFieldElement;
//use ark_bls12_381::Fr;
use acvm::FieldElement;
use acvm::acir::circuit::Program;
use noirc_artifacts::program::ProgramArtifact;
use noirc_driver::CompiledProgram;

fn load_noir_program(file_path: &str) -> Program<FieldElement> {
    let file = std::fs::read_to_string(file_path).expect("Unable to read ACIR file");
    let artifact: ProgramArtifact = serde_json::from_str(&file).expect("Failed to parse ACIR JSON");
    let compiled: CompiledProgram = artifact.into();
    compiled.program
}

fn main() {
    let program = load_noir_program("./noir_r1cs/circuit.json");
    println!("{}", program);
}
