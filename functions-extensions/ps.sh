function ps_kill_process_with_name() {
  NAME=${1:-celery}
  # Kill Process with a specific name
  ps -aef | grep "${NAME}" | grep -v grep | cut -f 5 -d ' ' | xargs -I {} bash -c 'echo "killing {}"; kill -9 {}'  
}


function pskill() {
	ps -ae -o pid,ppid,command | grep -v grep | grep ${@} | sed -E 's/^ *([0-9]+).*/\1/g' | xargs -n 1 kill -9
}
