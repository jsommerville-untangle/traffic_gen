#!/bin/ash

# set folder parameter 
folder=$1

# check for missing variables
if [ -z $1 ]; then
    echo "Missing parameter, please a name for summary file, ex:"
    echo "./mfw-sessions test_file"
    echo "The command above will output the summary to the screen and to /tmp/test_file.summary"
    exit
fi

# variables
start_time=$(sed '2q;d' /tmp/session_count_dates.log)
end_time=$(sed 'x;$!d' /tmp/session_count_dates.log)
high_sessions=$(cat /tmp/session_count.log  | sort -n -k1.2 | sed '$!d')
low_sessions=$(cat /tmp/session_count.log  | sort -n -k1.2 | sed -n 1p)
total_sessions=$(awk '{s+=$1} END {print s}' /tmp/session_count.log)
number_of_sessions=$(wc -l /tmp/session_count.log | cut -d " " -f 1)
average_sessions=$(echo "scale=4; $total_sessions/$number_of_sessions" | bc -l)
load_total=$(grep "Load Averages" /tmp/session_count_dates.log | awk -F'[, ]' '{print $5}' | awk '{s+=$1} END {print s}')
load_count=$(grep "Load Averages" /tmp/session_count_dates.log | wc -l)
load_average=$(echo "scale=4; $load_total/$load_count" | bc -l)

# echo title Session Summary
echo "Session Summary" | tee -a /tmp/$folder.summary

# echo times
echo "Start Time: $start_time" | tee -a /tmp/$folder.summary
echo "End Time: $end_time" | tee -a /tmp/$folder.summary
echo "Elapsed Time: $load_count minutes" | tee -a /tmp/$folder.summary

# echo session counts
echo "High Session Count: $high_sessions" | tee -a /tmp/$folder.summary
echo "Low Session Count: $low_sessions" | tee -a /tmp/$folder.summary
echo "Average Session Count: $average_sessions" | tee -a /tmp/$folder.summary

# echo load average
echo "CPU Load Average: $load_average" | tee -a /tmp/$folder.summary

# reset session_count.log and sessions_count_dates.log
rm /tmp/session_count.log
rm /tmp/session_count_dates.log