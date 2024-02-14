#!/usr/bin/env bash
if [ "$2" == "" ]; then
  if [ "$(uname -n)" = hopper ]; then
    YOURUSER=$(whoami)
    DEPLOYPASSWORD=$(grep password ~/.my.cnf|cut -d '=' -f2)
  else
    ssh hopper whoami || { echo "ssh hopper *must* work if hopperuser and mycnf password not provided" >&2; exit 1; }
    YOURUSER="$(ssh hopper whoami)"
    DEPLOYPASSWORD=$(ssh hopper grep password .my.cnf|cut -d '=' -f2)
  fi
else
  YOURUSER="$1"
  DEPLOYPASSWORD="$2"
fi
if test "$DEPLOYPASSWORD" = ""; then
  echo "could not get password from .my.cnf on hopper" >&2
  exit 1
fi
mkdir -p local
echo "user=$YOURUSER
webapp=docker-$YOURUSER-java
manager=docker-$YOURUSER-manager
baseurl=https://informatik.hs-bremerhaven.de" > local/config.txt

echo "service_password=$DEPLOYPASSWORD" > local/server.properties

echo "machine informatik.hs-bremerhaven.de login manager password $DEPLOYPASSWORD
machine localhost login manager password $DEPLOYPASSWORD" >local/netrc

echo "config.txt und  server.properties angelegt ($YOURUSER)"


