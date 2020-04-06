#!/bin/bash
es_home=/usr/local/elasticsearch
es_bin=${es_home}/bin
NAME="elasticsearch"
PORT=9200
# Check if user is root
if [ $(id -u) == "0" ]; then
    echo "Error: You must be saas to run this script!!"
    exit 1
fi
if [ -s /bin/ss ]; then
    StatBin=/bin/ss
else
    StatBin=/bin/netstat
fi
case "$1" in
    start)
        echo -n "Starting $NAME... "
        if $StatBin -tnl | grep -q ${PORT};then
            echo "$NAME (pid `pidof $NAME`) already running."
            exit 1
        fi
        ${es_bin}/elasticsearch -d -p ${es_bin}/es.pid
        if [ "$?" != 0 ] ; then
            echo " failed"
            exit 1
        else
            echo " done"
        fi
        ;;
    stop)
        echo -n "Stoping $NAME... "
        if ! $StatBin -tnl | grep -q ${PORT}; then
            echo "$NAME is not running."
            exit 1
        fi
        kill -SIGTERM `cat ${es_bin}/es.pid`
        if [ "$?" != 0 ] ; then
            echo " failed."
        else
            echo " done"
        fi
        ;;
    status)
        if $StatBin -tnl | grep -q ${PORT}; then
            echo "$NAME is running..."
        else
            echo "$NAME is stopped."
            exit 0
        fi
        ;;
    restart)
        $0 stop
        sleep 1
        $0 start
        ;;
    *)
        echo "Usage: $0 {start|stop|restart|status}"
        exit 1
        ;;
esac