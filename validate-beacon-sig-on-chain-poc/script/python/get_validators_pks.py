import json
from dotenv import load_dotenv

load_dotenv()
# Read the attestations data from JSON file
with open('script/data/11046320_attestations.json', 'r') as f:
    attestations_data = json.load(f)

# Get the first attestation's validators
first_attestation = attestations_data['data'][0]
validators = first_attestation['validators']
validator_chunks = [validators[i:i+100] for i in range(0, len(validators), 100)]

import os
import requests
all_validators = []
for i, chunk in enumerate(validator_chunks):
    api_key = os.getenv('BEACON_CHAIN_API_KEY')
    response = requests.post(
        f"https://beaconcha.in/api/v1/validator?apikey={api_key}",
        json={"indicesOrPubkey": ','.join(str(v) for v in chunk)}
    )
    # Add validators from this chunk to the aggregate list
    all_validators.extend(response.json()['data'])

print(f"Total validators aggregated: {len(all_validators)}")
# Save all validators with attestation and block info
attestation_data = {
    'block_slot': first_attestation['block_slot'],
    'block_root': first_attestation['block_root'], 
    'validators': all_validators
}

with open(f'script/data/validators_{first_attestation["block_slot"]}_0.json', 'w') as f:
    json.dump(attestation_data, f, indent=4)

print(f"Saved validator data for block {first_attestation['block_slot']}")
