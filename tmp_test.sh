#!/bin/sh
ip=10.12.14.1 # Enter IP of a web page the camera can reach for getting the time, e.g. your router.
make_offline() {
  while ! ps | grep -v grep | grep -q "ak_tuya_ipc"; do
    sleep 1
  done
  sleep 20
  killall -9 tuya_daemon.sh
  killall -9 ak_tuya_ipc
  cp /mnt/config/record/ak_tuya_ipc /tmp/
  mount --bind /tmp/ak_tuya_ipc /usr/sbin/ak_tuya_ipc
  /usr/sbin/ak_tuya_ipc > /dev/null &
  sleep 20
  set_date
}
set_date() {
  RAW_DATE=$(printf "HEAD / HTTP/1.0\r\n\r\n" | nc $ip 80 | grep "Date:")
  if [ -n "$RAW_DATE" ]; then
    set -- $RAW_DATE
    DAY=$3
    MON_STR=$4
    YEAR=$5
    TIME=$6
    HH=${TIME%%:*}
    MMS=${TIME#*:}
    MM=${MMS%%:*}
    SS=${MMS#*:}
    case $MON_STR in
      Jan) MON=01 ;; Feb) MON=02 ;; Mar) MON=03 ;; Apr) MON=04 ;;
      May) MON=05 ;; Jun) MON=06 ;; Jul) MON=07 ;; Aug) MON=08 ;;
      Sep) MON=09 ;; Oct) MON=10 ;; Nov) MON=11 ;; Dec) MON=12 ;;
    esac
    date -s "${YEAR}-${MON}-${DAY} ${HH}:${MM}:${SS}"
  fi
}
make_offline &
exit 0
