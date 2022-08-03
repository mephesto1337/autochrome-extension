#! /bin/bash

# Global variables
PROGNAME="$(basename "${0}")"
PROGDIR="$(dirname "${0}")"
CHROME_WRAPPER="${HOME}/.local/autochrome/chrome-wrapper"
CLEANUP_DONE=0

usage() {
    local exitcode=$1

    echo "Usages:"
    echo "  ${PROGNAME} [-h | --help] -p CHROME_WRAPPER"
    echo "Options:"
    echo "  -h, --help: displays this message and exits."
    echo "  -p, --prog: chrome wrapper binary (~/.local/autochrome/chrome-orig)."

    exit ${exitcode}
}

die() {
    local fmt="${1}"

    printf "\033[0;1;31m[ERROR] ${fmt}\033[0mn" "$@"
    exit 1
}

cleanup() {
    local why="${1:-unknow}"
    [[ ${CLEANUP_DONE} -ne 0 ]] && return

    CLEANUP_DONE=1
}
trap cleanup INT TERM EXIT ERR

options=$(getopt -o 'hp:' --long 'help,prog:' -n "${PROGNAME}" -- "$@")
if [[ $? -ne 0 ]]; then
    echo "Please check your getopt invocation" >&2
    exit 2
fi
eval set -- "${options}"
unset options

while true; do
    case "${1}" in
        -h | --help )
            usage 0
            ;;
        -p | --prog )
            CHROME_WRAPPER="${2}"
            shift 2
            ;;
        -- )
            shift
            break
            ;;
        -* )
            echo "Unhandled option '${1}" >&2
            exit 2
            ;;
    esac
done

exec ${CHROME_WRAPPER} --no-sandbox --pack-extension="${PROGDIR}/autochrome-tag"
