#!/bin/zsh

export TZ=$1
DISK=$2
_DATE=$(date "+%a %b %d %Y %I:%M %p")
DATE_DAY=$(echo $_DATE | awk '{print $1}')
DATE_MONTH=$(echo $_DATE | awk '{print $2}')
DATE_DAY_NUM=$(echo $_DATE | awk '{print $3}')
DATE_YEAR=$(echo $_DATE | awk '{print $4}')
DATE_TIME=$(echo $_DATE | awk '{print $5}')
DATE_AMPM=$(echo $_DATE | awk '{print $6}')
SSID=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | awk -F:  '($1 ~ "^ *SSID$"){print $2}' | cut -c 2-)
WIFI_IP=$(ipconfig getifaddr $(networksetup -listallhardwareports | grep -A 1 "Wi-Fi" | sed -n '2 p' | awk '{ print $2 }'))
ETH_IP=$(ipconfig getifaddr $(networksetup -listallhardwareports | grep -A 1 "Ethernet" | sed -n '2 p' | awk '{ print $2 }'))
# get idle cpu usage
IDLE=$(top -l 1| grep "CPU usage" | awk '{print $7}' | cut -d% -f1)
CPU_USAGE=$((100 - $IDLE))
_MAX_MEMORY=$(sysctl hw.memsize | awk '{print $2}')
_PAGE_SIZE=$(vm_stat | grep "page size of" | awk '{print $8}')
_MEM_USED=$(vm_stat | grep "Pages active" | awk '{print $3}' | sed 's/.$//')
MEM_USAGE=$(echo "scale=2; $_MEM_USED * $_PAGE_SIZE / $_MAX_MEMORY * 100" | bc)
# get the disk usage as a percentage
DISK_USAGE=$(df -H | grep "$DISK" | awk '{print $5}' | cut -d% -f1)

# using the above variables, print the output in json format using printf
printf '{"date_day":"%s","date_month":"%s","date_day_num":"%s","date_year":"%s","date_time":"%s","date_ampm":"%s","ssid":"%s","wifi_ip":"%s","eth_ip":"%s","cpu_usage":"%s","mem_usage":"%s","disk_usage":"%s"}' "$DATE_DAY" "$DATE_MONTH" "$DATE_DAY_NUM" "$DATE_YEAR" "$DATE_TIME" "$DATE_AMPM" "$SSID" "$WIFI_IP" "$ETH_IP" "$CPU_USAGE" "$MEM_USAGE" "$DISK_USAGE"