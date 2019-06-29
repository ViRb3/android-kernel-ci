#!/usr/bin/env bash

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

export REPO_ROOT=`pwd`

# Paths
export CLANG="${REPO_ROOT}/data/clang/clang-r353983d/bin/clang"
export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-linux-android-"
export ANYKERNEL_DIR="${REPO_ROOT}/data/anykernel2base"
export ANYKERNEL_IMAGE_DIR="${ANYKERNEL_DIR}"
export KERNEL_DIR="${REPO_ROOT}/data/kernel"

# Set to 0 to disable ccache
if [ -z ${AKCI_CCACHE} ] || [ ${AKCI_CCACHE} = 1 ]; then
    export CLANG="ccache ${CLANG}"
    mkdir -p "ccache"
    export CCACHE_BASEDIR="${REPO_ROOT}"
    export CCACHE_DIR="${REPO_ROOT}/ccache"
    export CCACHE_COMPILERCHECK="content"
fi

# If not defined gives long compiler name
export COMPILER_NAME="CLANG-8.0.4"

# Kernel config
export DEFCONFIG="redflare_defconfig"
export KERNEL_NAME="RedFlare-Kernel"

export KBUILD_BUILD_USER="elf"
export KBUILD_BUILD_HOST="buildstation"
export KBUILD_BUILD_VERSION=1
