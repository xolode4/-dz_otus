#!/bin/bash

echo -e "  PID TTY      STATE COMMAND"
for pid in /proc/[0-9]*; do
    pid=$(basename "$pid")
    if [[ -r "/proc/$pid/stat" ]]; then
        read -r _ comm state _ ppid _ session tty_nr _ flags _ utime stime _ _ _ _ _ _ _ _ _ vsize rss _ < "/proc/$pid/stat"
        #comm=${comm//[\(\)]/}
        
        tty="?"
        if [[ "$tty_nr" != "0" ]]; then
            tty=$(ls -l /dev | awk -v tty_nr="$tty_nr" '$5 == tty_nr {print $10; exit}')
            tty=${tty:-"?"}
        fi
        
        printf "%5d %-8s %s %s\n" "$ppid" "$tty" "$state" "$comm"
    fi
done