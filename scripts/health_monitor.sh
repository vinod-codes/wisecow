#!/usr/bin/env bash

set -euo pipefail

LOG_FILE=${LOG_FILE:-/var/log/health_monitor.log}
CPU_THRESHOLD=${CPU_THRESHOLD:-80}
MEM_THRESHOLD=${MEM_THRESHOLD:-80}
DISK_THRESHOLD=${DISK_THRESHOLD:-90}

timestamp() { date +"%F %T"; }

cpu_usage() {
  top -bn1 | awk -F'[, ]+' '/Cpu\(s\)/{print 100-$8}'
}

mem_usage() {
  free | awk '/Mem:/{printf("%.1f", $3/$2*100)}'
}

disk_usage_root() {
  df -P / | awk 'END{gsub("%","",$5); print $5}'
}

log() {
  echo "$(timestamp) $*" | tee -a "$LOG_FILE"
}

main() {
  mkdir -p "$(dirname "$LOG_FILE")" || true
  CPU=$(cpu_usage)
  MEM=$(mem_usage)
  DISK=$(disk_usage_root)

  log "CPU: ${CPU}% MEM: ${MEM}% DISK(/): ${DISK}%"

  awkcmp() { awk -v a="$1" -v b="$2" 'BEGIN{exit (a>b)?0:1}'; }

  awkcmp "$CPU" "$CPU_THRESHOLD" && log "ALERT: CPU usage high (${CPU}% > ${CPU_THRESHOLD}%)"
  awkcmp "$MEM" "$MEM_THRESHOLD" && log "ALERT: MEM usage high (${MEM}% > ${MEM_THRESHOLD}%)"
  awkcmp "$DISK" "$DISK_THRESHOLD" && log "ALERT: DISK usage high (${DISK}% > ${DISK_THRESHOLD}%)"

  ps aux --sort=-%cpu | head -n 6 | tee -a "$LOG_FILE" >/dev/null 2>&1 || true
}

main "$@"


