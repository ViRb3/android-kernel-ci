#!/bin/bash

echo "Syncing dependencies ..."

mkdir "data"

PIDS=""
./sync.sh https://github.com/mTresk/android_kernel_oneplus_msm8998.git "data/kernel" "${REF}" &
PIDS="${PIDS} $!"
./sync.sh https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 "data/gcc" &
PIDS="${PIDS} $!"
./sync.sh https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 "data/clang" &
PIDS="${PIDS} $!"
./sync.sh https://github.com/mTresk/AnyKernel2.git "data/anykernel" "redflare-op5" &
PIDS="${PIDS} $!"

for p in $PIDS; do
    wait $p || exit "$?"
done

echo "Done!"
