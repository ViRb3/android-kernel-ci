#!/usr/bin/env bash

export REPO_ROOT=`pwd`

# Paths
export CLANG="${REPO_ROOT}/data/clang/clang-r353983d/bin/clang"
export CROSS_COMPILE="${REPO_ROOT}/data/gcc/bin/aarch64-linux-android-"
export ANYKERNEL_DIR="${REPO_ROOT}/data/anykernel2base"
export ANYKERNEL_IMAGE_DIR="${ANYKERNEL_DIR}"
export KERNEL_DIR="${REPO_ROOT}/data/kernel"

# Define to enable ccache
if [ ! -z ${AKCI_CCACHE} ]; then
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
