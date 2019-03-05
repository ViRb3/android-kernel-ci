#!/usr/bin/env bash

REF="$1"; LABEL="$2"
. ./config.sh

process_build () {
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
        zip -r9 "${REPO_ROOT}/${LOCALVERSION}.zip" * -x README
        cd -
    fi
    
    rm -rf "${KERNEL_DIR}/out"
    rm -rf "${ANYKERNEL_IMAGE_DIR}"
    return ${BUILD_SUCCESS}
}

cd "${KERNEL_DIR}"

# Is this test release?
if [ -z "${LABEL}" ]
then
    VERSION="TEST-$(git rev-parse --short HEAD)"
else
    VERSION="${LABEL}"
fi
# Used by compiler
export LOCALVERSION="${KERNEL_NAME}-${VERSION}"

echo "Building ${LOCALVERSION} ..."
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
