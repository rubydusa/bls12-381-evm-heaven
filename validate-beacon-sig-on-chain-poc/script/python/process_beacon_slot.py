import json
from py_ecc.bls.g2_primitives import signature_to_G2
from py_ecc.optimized_bls12_381 import add as g2_add

# Read the beacon slot data from JSON file
with open('script/data/11046320.json', 'r') as f:
    slot_data = json.load(f)
# Read the attestations data from JSON file
with open('script/data/11046320_attestations.json', 'r') as f:
    attestations_data = json.load(f)
# Read the validators data from JSON file
with open('script/data/validators_11046320_0.json', 'r') as f:
    validators_data = json.load(f)

def get_slot_signature(slot_data):
    signature_str = bytes.fromhex(slot_data['data']['syncaggregate_signature'][2:])
    decompressed_sig_jacobian = signature_to_G2(signature_str)
    decompressed_sig_affine = (
        decompressed_sig_jacobian[0] / decompressed_sig_jacobian[2], 
        decompressed_sig_jacobian[1] / decompressed_sig_jacobian[2]
    )
    return decompressed_sig_affine

def get_attestations_signatures(attestations_data):
    decoded_sigs = [signature_to_G2(bytes.fromhex(attestation['signature'][2:])) for attestation in attestations_data['data']]
    aggregated_sig_jacobian = decoded_sigs[0] # Start with first signature
    for sig in decoded_sigs[1:]:
        aggregated_sig_jacobian = g2_add(aggregated_sig_jacobian, sig)
    aggregated_sig_affine = (
        aggregated_sig_jacobian[0] / aggregated_sig_jacobian[2], 
        aggregated_sig_jacobian[1] / aggregated_sig_jacobian[2]
    )
    return aggregated_sig_affine

sigA = get_slot_signature(slot_data)
sigB = get_attestations_signatures(attestations_data)

print("sigA")
print(sigA)
print("sigB")
print(sigB)