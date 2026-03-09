#!/usr/bin/env sh
set -euo pipefail
IFS=$'\n'

# 24-hours format
current_hour="$(date "+%H")"

# From 6 pm to 5:59 am: dark theme
# From 6 am to 5:59 pm: light theme
if [ "${current_hour}" -ge 18 ] || [ "${current_hour}" -lt 6 ]; then
    echo "Setting system color-scheme to dark..."
    gsettings set org.gnome.desktop.interface color-scheme prefer-dark
    if [ "$(qs list --all)" != "No running instances." ]; then
        echo "Setting Quickshell theme to dark..."
        dms ipc call theme dark
        echo "Setting Quickshell night light to true..."
        dms ipc call night enable
    fi
else
    echo "Setting system color-scheme to light..."
    gsettings set org.gnome.desktop.interface color-scheme prefer-light
    if [ "$(qs list --all)" != "No running instances." ]; then
        echo "Setting Quickshell theme to light..."
        dms ipc call theme light
        echo "Setting Quickshell night light to false..."
        dms ipc call night disable
    fi
fi
