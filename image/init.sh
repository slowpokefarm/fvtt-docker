#!/bin/sh

### BEGIN INIT INFO
# Provides:             dockercompose
# Required-Start:       $docker
# Required-Stop:        $docker
# Default-Start:        2 3 4 5
# Default-Stop:         0 1 6
# Short-Description:    Docker Services
### END INIT INFO

set -e

PROJECT_NAME=foundry
YAMLFILE=/var/foundry/docker-compose.yml
OPTS="-f $YAMLFILE -p $PROJECT_NAME"
UPOPTS="-d --no-recreate --no-build --no-deps"

. /lib/lsb/init-functions

case "$1" in
    start)
        log_daemon_msg "Starting Docker Compose" "dockercompose" || true
        docker-compose $OPTS up $UPOPTS
        ;;

    stop)
        log_daemon_msg "Stopping Docker Compose" "dockercompose" || true
        docker-compose $OPTS stop
        ;;

    reload)
        log_daemon_msg "Reloading Docker Compose" "dockercompose" || true
        docker-compose $OPTS up $UPOPTS
        ;;

    restart)
        docker-compose $OPTS stop
        docker-compose $OPTS up $UPOPTS
        ;;

    *)
        log_action_msg "Usage: /etc/init.d/dockercompose {start|stop|restart|reload}" || true
        exit 1
        ;;
esac

exit 0
