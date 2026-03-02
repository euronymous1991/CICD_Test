#!/usr/bin/env bash
# scripts/flash.sh
# Flash firmware to NUCLEO-F401RE via OpenOCD + ST-Link
 
set -euo pipefail
 
BINARY="${1:-build/stm32-nucleo-cicd.bin}"
FLASH_ADDR="0x08000000"
SWD_KHZ="${SWD_KHZ:-1000}"
 
if [[ ! -f "$BINARY" ]]; then
    echo "ERROR: Binary not found: $BINARY"
    echo "  Build first: cmake --build build"
    exit 1
fi
 
echo "==> Flashing: $BINARY"
echo "==> Target  : STM32F401RE @ $FLASH_ADDR"
echo "==> SWD     : ${SWD_KHZ} kHz (connect-under-reset)"

openocd \
    -f interface/stlink.cfg \
    -f target/stm32f4x.cfg  \
    -c "transport select hla_swd" \
    -c "adapter speed ${SWD_KHZ}" \
    -c "reset_config srst_only srst_nogate connect_assert_srst" \
    -c "init"               \
    -c "reset halt"         \
    -c "program $BINARY verify $FLASH_ADDR" \
    -c "reset run"          \
    -c "shutdown"
 
echo "==> Flash complete. Device is running."
