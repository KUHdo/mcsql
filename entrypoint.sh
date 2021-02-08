#!/bin/sh

if [ "$1" = "run" ]; then
    [ -z "$MYSQL_HOST" ] || 
    [ -z "$MYSQL_PASSWORD" ] || 
    [ -z "$S3_HOST" ] || 
    [ -z "$S3_KEY" ] || 
    [ -z "$S3_SECRET" ] || 
    [ -z "$S3_BUCKET" ] &&
    exit

    [ -n "$PREFIX" ] && pf="$PREFIX"- || pf=
    file="$pf$(date -Iseconds)"

    [ -z "$MYSQL_PORT" ] && MYSQL_PORT=3306
    [ -z "$MYSQL_USER" ] && MYSQL_USER=root

    mysqldump -h "$MYSQL_HOST" -P "$MYSQL_PORT" -u "$MYSQL_USER" -p"$MYSQL_PASSWORD" -A --single-transaction --routines --triggers > "$file"

    [ -s "$file" ] && gzip "$file" && file="$file".gz || exit

    alias=s3
    mc alias set "$alias" "$S3_HOST" "$S3_KEY" "$S3_SECRET" --api S3v4 > /dev/null

    target="$alias/$S3_BUCKET"


    if [ -n "$RM_OLDER_THAN" ]; then
        minutes=$(echo "$RM_OLDER_THAN" | awk '{print ($1 * 24 * 60) + ($2 * 60) + $3}')
        find . -mmin +"$((minutes-1))" -delete
        mc rm -r --force --older-than "$minutes"m --no-color --json "$target"
    fi

    exec mc cp "$file" "$target/" --no-color --json
else
    exec "$@"
fi
