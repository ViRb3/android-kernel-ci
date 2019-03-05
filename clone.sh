#!/usr/bin/env bash

URL="$1"; DIR="$2"; REF="$3"
GIT="git -C ${DIR}"
echo "Obtaining '${URL}' in '${DIR}' ..."

is_head () {
    $GIT ls-remote -q --heads --exit-code "origin" "${REF}"
    return $?
}

is_tag () {
    $GIT ls-remote -q --tags --exit-code "origin" "${REF}"
    return $?
}

update () {
    if is_head; then
        echo "Found branch, using its commit"
        $GIT remote set-branches --add origin "${REF}" || exit "$?"
        $GIT fetch origin "${REF}" --depth=1 || exit "$?"
        SRC="origin/${REF}"
    elif is_tag; then
        echo "Found tag, using its commit"
        $GIT fetch origin tag "${REF}" --depth=1 || exit "$?"
        SRC="${REF}"
    elif [ -z "${REF}" ]; then
        echo "No tag provided, using origin HEAD commit"
        $GIT fetch origin "HEAD" --depth=1 || exit "$?"
        SRC="origin/HEAD"
    else
        echo "No such tag or branch, aborting!"
        exit 1
    fi
    $GIT checkout -f --detach "${SRC}" || exit "$?"
}

if [ ! -d "${DIR}" ]; then
    mkdir "${DIR}"
    $GIT clone "${URL}" . -n --depth=1 || exit "$?"
fi

update

echo "Done!"
