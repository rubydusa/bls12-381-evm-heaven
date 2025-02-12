import pkgutil
import eth2spec

print("Modules in eth2spec:")
for module in pkgutil.iter_modules(eth2spec.__path__):
    if module.ispkg:
        print(f"{module.name}/")
        submodules = pkgutil.iter_modules([f"{eth2spec.__path__[0]}/{module.name}"])
        for submodule in submodules:
            print(f"  {submodule.name}")
    else:
        print(module.name)

print("Exported members of eth2spec.utils.bls:")
for name in dir(eth2spec.utils.bls):
    if not name.startswith('_'):  # Only print non-private members
        print(f"  {name}")

# eth2spec.utilz.bls exports:
# ----------------------------
#   Aggregate
#   AggregatePKs
#   AggregateVerify
#   BLS_MODULUS
#   FQ
#   FQ2
#   FastAggregateVerify
#   G1
#   G1_to_bytes48
#   G2
#   G2_POINT_AT_INFINITY
#   G2_to_bytes96
#   KeyValidate
#   STUB_COORDINATES
#   STUB_PUBKEY
#   STUB_SIGNATURE
#   Scalar
#   Sign
#   SkToPk
#   Verify
#   Z1
#   Z2
#   add
#   arkworks_G1
#   arkworks_G2
#   arkworks_GT
#   arkworks_Scalar
#   arkworks_bls
#   bls
#   bls_active
#   bytes48_to_G1
#   bytes96_to_G2
#   fastest_bls
#   milagro_bls
#   multi_exp
#   multiply
#   neg
#   only_with_bls
#   pairing_check
#   py_ecc_G1
#   py_ecc_G1_to_bytes48
#   py_ecc_G2
#   py_ecc_G2_to_bytes96
#   py_ecc_GT
#   py_ecc_Scalar
#   py_ecc_Z1
#   py_ecc_Z2
#   py_ecc_add
#   py_ecc_bls
#   py_ecc_bytes48_to_G1
#   py_ecc_bytes96_to_G2
#   py_ecc_final_exponentiate
#   py_ecc_mul
#   py_ecc_neg
#   py_ecc_pairing
#   py_ecc_prime_field_inv
#   signature_to_G2
#   use_arkworks
#   use_fastest
#   use_milagro
#   use_py_ecc
