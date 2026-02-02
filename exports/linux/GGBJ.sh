#!/bin/sh
printf '\033c\033]0;%s\a' GGBJ
base_path="$(dirname "$(realpath "$0")")"
"$base_path/GGBJ.x86_64" "$@"
