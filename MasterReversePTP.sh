#!/bin/bash

#################################################################################
# Copyright (c) 2014, Tal Mizrahi, Technion - Israel Institute of Technology
# All rights reserved.
#
# ReversePTP is a free software, under the BSD 2-clause license.
#
# Redistribution and use in source and binary forms, with or without modification,
# are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
# GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
# OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#################################################################################


function printhelp {
      echo "MasterReversePTP.sh <-i interface> [-h] [-d domain] [-u unicast address] [-l log file name] [-k] [-n]"
}
if [ $# -eq 0 ] || [ $1 == "-h" ]
then
  printhelp
  exit
fi

# Default values:
interface=0
intexists=0
killPtpd=0
domain=0
killNTP=0
logCmd=""
addressMode="-y"

# Parse command line options:
while test $# -gt 0
do
    case $1 in
  -d)
      domain=$2
      shift
      ;;
  -i)
      interface=$2
      intexists=1
      shift
      ;;
  -u)
      address=$2
      addressMode="-u ${address}"
      shift
      ;;
  -l)
      logfile=$2
      logCmd="-S ${logfile}"
      shift
      ;;
  -k)
      killPtpd=1
      ;;
  -n)
      killNTP=1
      ;;
  *)
      printhelp
      exit 0
      ;;
  esac
  shift
done

if [ $intexists -eq 0 ]
then
  echo "Error: please use <-i interface>"
  echo "Usage:"
  printhelp
  exit
fi

# kill currently running PTP daemon
if [ $killPtpd -eq 1 ]
then
  sudo start-stop-daemon -K -q -x /usr/local/sbin/ptpd2
fi

# kill currently running NTP daemon
if [ $killNTP -eq 1 ]
then
  sudo service ntp stop
fi

# flags: master, interface, unicast/hybrid mode, ignore locking, end-to-end, domain, no time update, log delay interval, statistics file, use libpcap
sudo ptpd2 -M -i $interface $addressMode -L -E -d $domain -n -r 0 $logCmd --ptpengine:use_libpcap=y
echo "ReversePTP master is running."
