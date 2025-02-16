#!/bin/sh
echo -ne '\033c\033]0;CalgaryHacks2025\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/CalgaryHacks2025.x86_64" "$@"
