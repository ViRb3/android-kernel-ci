#!/bin/bash

LABEL="$1"; REF="$2"
. ./config.sh

process_build () {
    # Used by compiler
    export LOCALVERSION="-${FULLNAME}"
    # Remove defconfig localversion to prevent overriding
    sed -i -r "s/(CONFIG_LOCALVERSION=).*/\1/" "${KERNEL_DIR}/arch/arm64/configs/${DEFCONFIG}"

    make O=out ARCH=arm64 ${DEFCONFIG}
    make -j$(nproc --all) O=out \
        ARCH=arm64 \
        CC="${CLANG}" \
        CLANG_TRIPLE=aarch64-linux-gnu- \
        CROSS_COMPILE="${CROSS_COMPILE}" \
        KBUILD_COMPILER_STRING="$(${CLANG} --version | head -n 1 | perl -pe 's/\(http.*?\)//gs' | sed -e 's/  */ /g')" \
    
    BUILD_SUCCESS=$?
    
    if [ ${BUILD_SUCCESS} -eq 0 ]; then
        mkdir -p "${ANYKERNEL_IMAGE_DIR}"
        cp -f "${KERNEL_DIR}/out/arch/arm64/boot/Image.gz-dtb" "${ANYKERNEL_IMAGE_DIR}/Image.gz-dtb"
        cd "${ANYKERNEL_DIR}"
        zip -r9 "${REPO_ROOT}/${FULLNAME}.zip" * -x README
        cd -
    fi
    
    rm -rf "${KERNEL_DIR}/out"
    rm "${ANYKERNEL_IMAGE_DIR}/Image.gz-dtb"
    return ${BUILD_SUCCESS}
}

cd "${KERNEL_DIR}"

# Ensure the kernel has a label
if [ -z "${LABEL}" ]; then
    LABEL="SNAPSHOT-$(git rev-parse --short HEAD)"
fi
FULLNAME="${KERNEL_NAME}-${LABEL}"

echo "Building ${FULLNAME} ..."
process_build
BUILD_SUCCESS=$?

if [ ${BUILD_SUCCESS} -eq 0 ]; then
    echo "Done!"
    # Save for use by later build stages
    git log -1 > "${REPO_ROOT}/$(git rev-parse HEAD).txt"
    # Some stats
    ccache --show-stats
else
    echo "Error while building!"
fi

cd "${REPO_ROOT}"
exit ${BUILD_SUCCESS}
