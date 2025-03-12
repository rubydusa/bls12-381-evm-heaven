import json
from pathlib import Path

fp_order = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab

script_dir = Path(__file__).parent
with open(script_dir / 'verification_key.json', 'r') as f:
    vk = json.load(f)
with open(script_dir / 'proof.json', 'r') as f:
    proof = json.load(f)
with open(script_dir / 'public.json', 'r') as f:
    public = json.load(f)

def process_fp(fp):
    hex_str = hex(int(fp))[2:].zfill(128)
    part1 = '0x' + hex_str[:64]
    part2 = '0x' + hex_str[64:]
    return [part1, part2]

def process_scalar(scalar):
    hex_str = hex(int(scalar))[2:].zfill(64)
    return '0x' + hex_str

alpha = process_fp(vk['vk_alpha_1'][0]) + process_fp(vk['vk_alpha_1'][1])

beta = [
    process_fp(vk['vk_beta_2'][0][0]) + process_fp(vk['vk_beta_2'][0][1]),
    process_fp(vk['vk_beta_2'][1][0]) + process_fp(vk['vk_beta_2'][1][1])
]

gamma = [
    process_fp(vk['vk_gamma_2'][0][0]) + process_fp(vk['vk_gamma_2'][0][1]),
    process_fp(vk['vk_gamma_2'][1][0]) + process_fp(vk['vk_gamma_2'][1][1])
]

delta = [
    process_fp(vk['vk_delta_2'][0][0]) + process_fp(vk['vk_delta_2'][0][1]),
    process_fp(vk['vk_delta_2'][1][0]) + process_fp(vk['vk_delta_2'][1][1])
]

ic = [process_fp(x[0]) + process_fp(x[1]) for x in vk['IC']]

pi_a_neg_y = str(fp_order - int(proof['pi_a'][1]))
pi_a = process_fp(proof['pi_a'][0]) + process_fp(pi_a_neg_y)
pi_b = [process_fp(proof['pi_b'][0][0]) + process_fp(proof['pi_b'][0][1]), process_fp(proof['pi_b'][1][0]) + process_fp(proof['pi_b'][1][1])]
pi_c = process_fp(proof['pi_c'][0]) + process_fp(proof['pi_c'][1])
pub_signals = [process_scalar("1")] + [process_scalar(x) for x in public]

print(len(''.join([x[2:] for x in pi_a])))
print(len(''.join([x[2:] for x in pi_b[0]])))
print(len(''.join([x[2:] for x in pi_b[1]])))
print(len(''.join([x[2:] for x in pi_c])))
print(len(''.join([x[2:] for x in pub_signals])))

calldata = ''.join([x[2:] for x in pi_a]) + \
      ''.join([x[2:] for x in pi_b[0]]) + \
      ''.join([x[2:] for x in pi_b[1]]) + \
      ''.join([x[2:] for x in pi_c]) + \
      ''.join([x[2:] for x in pub_signals])
print(len(calldata))

result = {
    'alpha': alpha,
    'beta': beta,
    'gamma': gamma,
    'delta': delta,
    'ic': ic,
    'calldata': calldata
}

with open(script_dir / 'verification_key_processed.json', 'w') as f:
    json.dump(result, f, indent=4)