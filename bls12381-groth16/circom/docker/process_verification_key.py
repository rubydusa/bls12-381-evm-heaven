import sys
import json

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
    if len(sys.argv) != 3:
        print("Usage: python process_verification_key.py <verification_key.json> <output.json>")
        sys.exit(1)
        
    vk_path = sys.argv[1]
    output_path = sys.argv[2]
    with open(vk_path, 'r') as f:
        vk = json.load(f)

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

    result = {
        'alpha': alpha,
        'beta': beta,
        'gamma': gamma,
        'delta': delta,
        'ic': ic
    }
    with open(output_path, 'w') as f:
        json.dump(result, f, indent=4)


if __name__ == "__main__":
    main()