#!/bin/bash
# Ensure we're in the script's directory
cd "$(dirname "$0")"
# Create Python virtual environment
python3 -m venv venv
# Activate virtual environment
source venv/bin/activate
# Install py_ecc
pip3 install py_ecc
# Initialize and update git submodules
git submodule init
git submodule update

# Install eth2spec from dependencies folder
pip3 install -e ./dependencies/consensus-specs
