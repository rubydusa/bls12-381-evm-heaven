import json
import sys

fp_order = 0x1a0111ea397fe69a4b1ba7b6434bacd764774b84f38512bf6730d2a0f6b0f6241eabfffeb153ffffb9feffffffffaaab


def process_fp(fp):
    hex_str = hex(int(fp))[2:].zfill(128)
    part1 = '0x' + hex_str[:64]
    part2 = '0x' + hex_str[64:]
    return [part1, part2]


def process_scalar(scalar):
    hex_str = hex(int(scalar))[2:].zfill(64)
    return '0x' + hex_str


def main():
    if len(sys.argv) != 4:
        print("Usage: python generate_proof_calldata.py <proof.json> <public.json> <output.json>")
        sys.exit(1)

    proof_path = sys.argv[1]
    public_path = sys.argv[2]
    output_path = sys.argv[3]

    with open(proof_path, 'r') as f:
        proof = json.load(f)
    with open(public_path, 'r') as f:
        public = json.load(f)

    pi_a_neg_y = str(fp_order - int(proof['pi_a'][1]))
    pi_a = process_fp(proof['pi_a'][0]) + process_fp(pi_a_neg_y)
    pi_b = [process_fp(proof['pi_b'][0][0]) + process_fp(proof['pi_b'][0][1]), process_fp(proof['pi_b'][1][0]) + process_fp(proof['pi_b'][1][1])]
    pi_c = process_fp(proof['pi_c'][0]) + process_fp(proof['pi_c'][1])
    pub_signals = [process_scalar(x) for x in public]

    calldata = ''.join([x[2:] for x in pi_a]) + \
        ''.join([x[2:] for x in pi_b[0]]) + \
        ''.join([x[2:] for x in pi_b[1]]) + \
        ''.join([x[2:] for x in pi_c]) + \
        ''.join([x[2:] for x in pub_signals])
    
    result = {
        'pi_a': pi_a,
        'pi_b': pi_b,
        'pi_c': pi_c,
        'pub_signals': pub_signals,
        'calldata': calldata
    }

    with open(output_path, 'w') as f:
        json.dump(result, f, indent=4)


if __name__ == "__main__":
    main()