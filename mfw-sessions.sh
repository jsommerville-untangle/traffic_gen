#!/bin/ash

# loop to track session counts on mfw every 2 minutes
while true

do
    # output current active session count to /tmp/session_count.log
    cat /proc/net/nf_conntrack | wc -l >> /tmp/session_count.log

    # output current active session count and date to /tmp/session_count.log
    date >> /tmp/session_count_dates.log
    cat /proc/net/nf_conntrack | wc -l >> /tmp/session_count_dates.log

    # show date
    date

    # echo output to screen
    cat /proc/net/nf_conntrack | wc -l

    # sleep 2 minutes
    sleep 120

done