function canReach(){
	/sbin/ping -c 1 -t 1 $1 1>/dev/null 2>/dev/null && /bin/echo "UP: $1" || /bin/echo "DOWN: $1";
}
