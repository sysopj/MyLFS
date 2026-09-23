#!/usr/bin/env bash

# Prevent unexpanded globs from passing as literal strings when no files exist
shopt -s nullglob

# Restore cursor and clear screen on exit (Ctrl+C)
trap 'tput cnorm; clear; exit' INT TERM

tput civis
clear

while true; do
    # Reset cursor to top-left (0,0) for flicker-free update
    tput cup 0 0

    # Dynamically find whatever log files exist right now
    files=( extension_*/logs/*.log logs-*/*.log )

    if [ ${#files[@]} -gt 0 ]; then
        tail -n 61 "${files[@]}" 2>/dev/null
    else
        echo -e "Waiting for active log files...\033[K"
    fi

    # Erase leftover lines from screen if log length or count shrinks
    tput ed

    sleep 0.5
done