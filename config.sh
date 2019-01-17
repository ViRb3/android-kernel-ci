#!/usr/bin/env bash

mkdir "data"
./clone.sh https://github.com/mTresk/android_kernel_oneplus_msm8998.git "data/kernel" "$1" || exit "$?"
./clone.sh https://android.googlesource.com/platform/prebuilts/gcc/linux-x86/aarch64/aarch64-linux-android-4.9 "data/gcc" || exit "$?"
./clone.sh https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86 "data/clang" || exit "$?"
./clone.sh https://github.com/mTresk/AnyKernel2.git "data/anykernel2base" "redflare-op5" || exit "$?"

export REPO_ROOT=`pwd`

mkdir "ccache"
export CCACHE_BASEDIR="${REPO_ROOT}"
export CCACHE_DIR="${REPO_ROOT}/ccache"
export CCACHE_COMPILERCHECK=content

# Paths
export CLANG="ccache ${REPO_ROOT}/data/clang/clang-r346389b/bin/clang"
export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-linux-android-"
export ANYKERNELBASE_DIR="${REPO_ROOT}/data/anykernel2base"
export KERNEL_DIR="${REPO_ROOT}/data/kernel"

# If not defined gives long compiler name
export COMPILER_NAME="CLANG-8.0.6"

# Kernel config
export DEFCONFIG="redflare_defconfig"
export KERNEL_NAME="RedFlare-Kernel"
