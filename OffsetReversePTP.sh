#!/bin/bash

function printhelp {
      echo "OffsetReversePTP.sh <-d domain> [-h] [-l log file name]"
}
if [ $# -eq 0 ] || [ $1 == "-h" ]
then
  printhelp
  exit
fi

# Default values:
logfile="LogReversePTPSlave"
domain=0

# Parse command line options:
while test $# -gt 0
do
    case $1 in
  -d)
      domain=$2
      shift
      ;;
  -l)
      logfile=$2
      shift
      ;;
  *)
      printhelp
      exit 0
      ;;
  esac
  shift
done

LogFileName=${logfile}_${domain}.txt
if [ -f $LogFileName ]
then
  state=$(tail -1 $LogFileName | awk '{print $3}')
  if [ $state != "slv," ]
  then
    echo "Error: slave in domain ${domain} is not in slave state."
    exit
  fi
  offset=$(tail -1 $LogFileName | awk '{print $6}' | sed 's/\,//')
  echo $offset
else
  echo "Error: file $LogFileName does not exist. Make sure you have used the -l flag correctly."
fi 

