#!/bin/bash
# web 컨테이너가 3개 미만이면 compose로 다시 3개로 맞춘다
cd "$(dirname "$0")" || exit 1
DESIRED=3
while true; do
    running=$(docker compose ps --status running -q web | wc -l)
    if [ "$running" -lt "$DESIRED" ]; then
        echo "$(date +%T) web=$running -> $DESIRED 로 복구"
        docker compose up -d --scale web=$DESIRED
    fi
    sleep 5
done
