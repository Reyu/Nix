#! @bash@/bin/bash -e

shopt -s nullglob

export PATH=/empty
for i in @path@; do PATH=$PATH:$i/bin; done

usage() {
    echo "usage: $0 [-d <boot-dir>] [-g <num-generations>]" >&2
    exit 1
}

default=                # Default configuration
target=/boot            # Target directory
numGenerations=0        # Number of other generations to include in the menu

while getopts "c:d:g:" opt; do
    case "$opt" in
        c) default="$OPTARG" ;;
        d) target="$OPTARG" ;;
        g) numGenerations="$OPTARG" ;;
        \?) usage ;;
    esac
done

mkdir -p "${target}/nixos"

# Convert a path to a file in the Nix store such as
# /nix/store/<hash>-<name>/file to <hash>-<name>-<file>.
cleanName() {
    local path="$1"
    echo "$path" | sed 's|^/nix/store/||' | sed 's|/|-|g'
}

# Copy a file from the Nix store to $target/nixos.
declare -A filesCopied

copyToKernelsDir() {
    local src dst
    src=$(readlink -f "$1")
    dst="$target/nixos/$(cleanName "$src")"
    # Don't copy the file if $dst already exists.  This means that we
    # have to create $dst atomically to prevent partially copied
    # kernels or initrd if this script is ever interrupted.
    if ! test -e "$dst"; then
        local dstTmp="$dst.tmp.$$"
        cp -r "$src" "$dstTmp"
        mv "$dstTmp" "$dst"
    fi
    filesCopied[$dst]=1
    result=$dst
}

# Copy kernel and initrd to $target/nixos, and echo out a menu entry
addEntry() {
    local path tag
    path=$(readlink -f "$1")
    tag="$2" # Generation number or 'default'

    if ! test -e "$path/kernel" -a -e "$path/initrd"; then
        return
    fi

    copyToKernelsDir "$path/kernel"; kernel=$result
    copyToKernelsDir "$path/initrd"; initrd=$result

    timestampEpoch=$(stat -L -c '%Z' "$path")

    timestamp=$(date "+%Y-%m-%d %H:%M" -d "@$timestampEpoch")
    nixosLabel="$(cat "$path/nixos-version")"
    extraParams="$(cat "$path/kernel-params")"

    echo -n "NixOS-Configuration_${tag}-${timestamp}-${nixosLabel}"
    echo -n "|elf|kernel /nixos/$(basename "$kernel")"
    echo -n "|initrd /nixos/$(basename "$initrd")"
    echo "|append init=$path/init $extraParams"
}

tmpFile="$target/kexec_menu.txt.tmp.$$"

addEntry "$default default" >> "$tmpFile"

if [ "$numGenerations" -gt 0 ]; then
    # Add up to $numGenerations generations of the system profile to the menu,
    # in reverse (most recent to least recent) order.
    for generation in $(
            (cd /nix/var/nix/profiles && ls -d system-*-link) \
            | sed 's/system-\([0-9]\+\)-link/\1/' \
            | sort -n -r \
            | head -n "$numGenerations"); do
        link=/nix/var/nix/profiles/system-$generation-link
        addEntry "$link" "$generation"
    done >> "$tmpFile"
fi

mv -f "$tmpFile" "$target/kexec_menu.txt"

# Remove obsolete files from $target/nixos.
for fn in "$target"/nixos/*; do
    if ! test "${filesCopied[$fn]}" = 1; then
        echo "Removing no longer needed boot file: $fn"
        chmod +w -- "$fn"
        rm -rf -- "$fn"
    fi
done
