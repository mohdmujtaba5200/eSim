#!/bin/bash
echo "Bypassing broken wrapper logic -> Launching eSim installer..."
export VERSION_ID="24.04"
export UBUNTU_CODENAME="noble"
bash install-eSim-scripts/install-eSim-24.04.sh "$@"
