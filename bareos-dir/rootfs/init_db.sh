#!/bin/bash

set -e # Exit if any command errors

export PGPASSWORD=$DB_PASS

# wait until Database Host is ready
MAX_LOOPS=100
i=0
while ! psql --host=$DB_HOST --username=$DB_USER -d template1 -c "SELECT 'ping'" &>/dev/null ; do
  i=`expr $i + 1`
  if [ $i -ge $MAX_LOOPS ]; then
    echo "$(date) - ${DB_HOST} still not reachable, giving up"
    exit 1
  fi
  echo "$(date) - waiting for ${DB_HOST} to come up"
  sleep 1
done


PGSQL_CMD="psql --host=$DB_HOST --username=$DB_USER"

# Create Database if not exists
if ! $PGSQL_CMD -c '\q' &>/dev/null; then
  echo "Create Database"
  $PGSQL_CMD -d template1 -c "CREATE DATABASE ${DB_NAME} ENCODING 'SQL_ASCII' LC_COLLATE 'C' LC_CTYPE 'C' TEMPLATE template0;" 1>/dev/null
  $PGSQL_CMD -c "ALTER DATABASE ${DB_NAME} SET datestyle TO 'ISO, YMD';" 1>/dev/null
fi

PGSQL_CMD="$PGSQL_CMD --dbname=$DB_NAME"

# Init Schema if theres no Version table
if ! $PGSQL_CMD -tAc "SELECT 'Version'::regclass" &>/dev/null ; then
  echo "Init Database"
  $PGSQL_CMD -f /usr/lib/bareos/scripts/ddl/creates/postgresql.sql 1>/dev/null
  # $PGSQL_CMD -f /usr/lib/bareos/scripts/ddl/grants/postgresql.sql 1>/dev/null
fi

# Fetch current Schema Version
CUR_DB_VERSION=`$PGSQL_CMD -tAc "SELECT VersionID FROM Version"`
if [ "$CUR_DB_VERSION" == "" ] ; then
  echo "ERROR: Could not fetch current Schema Version"
  exit 1
fi
if [ "$CUR_DB_VERSION" -gt "$BAREOS_DB_VERSION" ] ; then
  echo "ERROR: Schema Version is to new for this Bareos Version"
fi
# Try to upgrade Schema
if [ "$CUR_DB_VERSION" -lt "$BAREOS_DB_VERSION" ] ; then
  echo "WARN: Schema Version differs: ${CUR_DB_VERSION} but should ${BAREOS_DB_VERSION}, try to upgrade"
  VERUP_CURR=$CUR_DB_VERSION
  for i in `ls /usr/lib/bareos/scripts/ddl/updates/postgresql.*.sql` ; do
    FROM=`echo $i | cut -d"." -f 2 | cut -d"_" -f 1`
    TO=`echo $i | cut -d"." -f 2 | cut -d"_" -f 2`
    if [ "$VERUP_CURR" = "$FROM" ] && [ "$VERUP_CURR" -lt "$BAREOS_DB_VERSION" ]; then
      echo "Apply Schema Update $i";
      $PGSQL_CMD -f /usr/lib/bareos/scripts/ddl/updates/$i 1>/dev/null
      VERUP_CURR=$TO
    fi
  done
fi
