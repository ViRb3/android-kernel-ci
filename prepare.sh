#!/usr/bin/env bash

echo "Installing required packages ..."

apt update > /dev/null || exit "$?"

# required
apt install git make build-essential ccache curl zip -y > /dev/null || exit "$?"
# per kernel
apt install bc libssl-dev python -y > /dev/null || exit "$?"

echo "Syncing required repositories ..."

mkdir -p "data"

PIDS=""
./sync.sh https://github.com/mTresk/android_kernel_oneplus_msm8998.git "data/kernel" "${REF}" &
PIDS+=" $!"
./sync.sh https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 "data/gcc" &
PIDS+=" $!"
./sync.sh https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 "data/clang" &
PIDS+=" $!"
./sync.sh https://github.com/mTresk/AnyKernel2.git "data/anykernel2base" "redflare-op5" &
PIDS+=" $!"

for p in $PIDS; do
    wait $p || exit "$?"
done

echo "Done!"
