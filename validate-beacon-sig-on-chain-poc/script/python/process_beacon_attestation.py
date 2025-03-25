import json
from py_ecc.bls.g2_primitives import signature_to_G2, pubkey_to_G1
from py_ecc.optimized_bls12_381 import add as ec_add

# Read the beacon slot data from JSON file
with open('script/data/11046320.json', 'r') as f:
    slot_data = json.load(f)
# Read the attestations data from JSON file
with open('script/data/11046320_attestations.json', 'r') as f:
    attestations_data = json.load(f)
# Read the validators data from JSON file
with open('script/data/validators_11046320_0.json', 'r') as f:
    validators_data = json.load(f)

def get_aggregate_pubkey(validators):
    agg = pubkey_to_G1(bytes.fromhex(validators[0]["pubkey"][2:]))
    for v in validators[1:]:
        pubkey = pubkey_to_G1(bytes.fromhex(v["pubkey"][2:]))
        agg = ec_add(pubkey, agg)

    agg = (
        agg[0] / agg[2],
        agg[1] / agg[2]
    )
    return agg

def get_attestation_signature_(attestation):
    signature_str = bytes.fromhex(attestation['signature'][2:])
    decompressed_sig_jacobian = signature_to_G2(signature_str)
    decompressed_sig_affine = (
        decompressed_sig_jacobian[0] / decompressed_sig_jacobian[2], 
        decompressed_sig_jacobian[1] / decompressed_sig_jacobian[2]
    )

    return decompressed_sig_affine

agg_pubkey = get_aggregate_pubkey(validators_data["validators"])
attestation_data = attestations_data["data"][0]
attestation_sig = get_attestation_signature_(attestation_data)

# TODO: Verify the attestation signature using eth2spec `compute_signing_root` and `AttestationData`