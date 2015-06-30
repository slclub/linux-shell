#!/usr/bin/env bash
date;
echo "uptime";
uptime;

echo "Currently connect:";
w
echo "==========================================";
echo last login;
last -a | head -3;
echo "==========================================";
echo "Disk and memory usage:";
df -h | xargs | awk '{print "Free/Total disk:" $11 " /" $9}';
free -m | xargs | awk '{print "Free/Total memory : " $17 "/" $8 "MB"}';
echo "==========================================";
start_log=`head -1 /var/log/messages |cut -c 1-12`;
oom=`grep -ci kill /var/log/messages`
echo -n "OOM errors since $start_log :" $oom
echo ""
echo "=========================================="

echo "Utilization and most expensive processes:"
top -b |head -3
echo
top -b |head -10 |tail -4
echo "=========================================="
#echo "Open TCP ports:"
#nmap -p -T4 127.0.0.1
echo "=========================================="
echo "Current connections:"
ss -s
echo "=========================================="
echo "processes:"
ps auxf --width=200 | head -10
echo "=========================================="
echo "vmstat:"
vmstat 1 5
