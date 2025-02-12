import json
import eth2spec
import eth2spec.utils.bls as bls

# Read the beacon slot data from JSON file
with open('script/data/11046320.json', 'r') as f:
    beacon_data = json.load(f)
    
print("Loaded beacon data for slot:", beacon_data['data']['slot'])
signature_str = bytes.fromhex(beacon_data['data']['signature'][2:])
signature = bls.bytes96_to_G2(signature_str)
print("Members of signature:")
for attr in dir(signature):
    if not attr.startswith('_'):  # Skip private members
        print(f"  {attr}")

# https://github.com/crate-crypto/py-arkworks-bls12381/
# TODO: unforutneayly, the py-arkworks-bls12381 library does not allow to read G2 point coordinates and neither does it allow to show it uncompressed.
# use py_ecc to read the compressed point and from it build the json data for solidity script