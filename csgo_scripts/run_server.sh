#!/bin/bash

export CSGO_BASE_DIR="/data/steam/csgo_app"

export LD_LIBRARY_PATH="${CSGO_BASE_DIR}:${CSGO_BASE_DIR}/bin"

# avoid the error:
#  Failed to open libtier0.so (/data/steam/csgo_app/bin/libgcc_s.so.1: version `GCC_7.0.0' not found (required by /lib/i386-linux-gnu/libstdc++.so.6))
if [ -f ${CSGO_BASE_DIR}/bin/libgcc_s.so.1 ]
then
  echo "III removing ${CSGO_BASE_DIR}/bin/libgcc_s.so.1"
  mv ${CSGO_BASE_DIR}/bin/libgcc_s.so.1 ${CSGO_BASE_DIR}/bin/libgcc_s.so.1.bck
fi

${CSGO_BASE_DIR}/srcds_linux -game csgo -usercon -net_port_try 1 -tickrate 128 -nobots +game_type 0 +game_mode 1 +mapgroup mg_active +map de_mirage