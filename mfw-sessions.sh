#!/bin/ash

# recreate export on each run
mv /tmp/sessions_report /tmp/sessions_report-$(date -Iminutes)
echo "date,sesscount,load_1_min,load_5_min,load_15_min" > /tmp/sessions_report

# loop to track session counts on mfw every 2 minutes
while true

do
    # set count variable
    count=$(cat /proc/net/nf_conntrack | wc -l)

    # set date variable
    date=$(date '+%s')

    # set load variable
    uptime=$(uptime | cut -d ':' -f 5)

    # output current active session count to /tmp/session_count.log
    echo $count >> /tmp/session_count.log

    # output current active date, load averages, and session count to /tmp/session_count.log
    echo "Load Averages (1/5/15 minutes):$uptime" >> /tmp/session_count_dates.log
    echo $date >> /tmp/session_count_dates.log
    echo $count >> /tmp/session_count_dates.log

    # echo date, load average, and count to screen
    echo "Date: $date"
    echo "Load Averages (1/5/15 minutes):$uptime"
    echo -e "Session Count: $count\n"

    # Echo that stuff into a csv
    echo "$date,$count,$uptime" >> /tmp/sessions_report

    # sleep 1 minutes
    sleep 60

done