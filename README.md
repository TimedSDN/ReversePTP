Introduction
============
ReversePTP is a PTP variant for Software Defined Networks (SDN). ReversePTP is based on PTP, but is conceptually reversed; in ReversePTP all nodes (SDN switches) in the network function as PTP masters and distribute time to a single node, the controller, which functions as the PTP slave. Hence, all computations and bookkeeping are performed by the controller, whereas the 'dumb' switches are only required to send it their current time periodically. In accordance with the SDN paradigm, the controller is the 'brain', making ReversePTP flexible and programmable from an SDN programmer's perspective.

The TimedSDN Project
====================
ReversePTP is part of the [TimedSDN project].

License
=======
ReversePTP is a free software, under the BSD 2-clause license. For further details see LICENSE.txt.

Prerequisites
=============
This software was tested on Ubuntu 12.04.

Before using ReversePTP:

- Install PTPd from: http://ptpd.sourceforge.net/

  This software was tested with PTPd version 2.3.0.

- Disable NTP (or use the -n option - see below):

  > sudo service ntp stop

Using ReversePTP
================
One machine is used as the slave (the controller in SDN), and the other N machines function as the master.
Each master machine runs the MasterReversePTP.sh script, which simply runs a PTPd master.
The slave machine runs the SlaveReversePTP.sh script, which invokes N instances of PTPd in slave mode.
The slave machine keeps a statistics log file for each of the N instances. This log file includes the OffsetFromMaster.
Applications that run on the slave machine can use the OffsetReversePTP.sh script to retrieve the offset from a specific master.

MasterReversePTP
================
Usage:
MasterReversePTP.sh <-i interface> [-h] [-d domain] [-u unicast address] [-l log file name] [-k] [-n]

-d domain    - specifies the domain number of this master. The default is 0.

-h           - displays a short help.

-i interface - specifies the interface through which PTP messages are sent and received.

-k           - indicates that all existing instances of PTPd will be killed when this script starts running.

-l log file  - if this option is used, PTPd generates a statistics log file named according to the given parameter.

-n           - indicates that NTP will be killed when this script starts running.

-u address   - if this option is used, PTP is run in unicast mode, and the address parameter specifies the slave's IP address. In unicast mode both the master and slave must be run with the -u option. If this option is not used, ReversePTP runs in hybrid mode.

SlaveReversePTP
===============
Usage:
SlaveReversePTP.sh <-i interface> <-m number of ReversePTP instances> [-h] [-d domain] [-f first master address] [-l log file name] [-k] [-n]

-d domain    - specifies the domain number of the first slave instance. The default is 0. The N instances use N consecutive domain numbers following this number.

-h           - displays a short help.

-i interface - specifies the interface through which PTP messages are sent and received.

-k           - indicates that all existing instances of PTPd will be killed when this script starts running.

-l log file  - specifies the name of the statistics log file. For every slave instance a suffix will be added according to its domain number. If this option is not used, the name of the log file is LogReversePTPSlave_<domain_number>.txt.

-n           - indicates that NTP will be killed when this script starts running.

-u address   - if this option is used, PTP is run in unicast mode, and the address parameter specifies the master's IP address. In unicast mode both the master and slave must be run with the -u option. If this option is not used, ReversePTP runs in hybrid mode.

OffsetReversePTP
================
Usage: 
OffsetReversePTP.sh <-d domain> [-h] [-l log file name]

-d domain    - specifies the domain number of the master for which the offset should be displayed.

-h           - displays a short help.

-l log file  - the name of the statistics log file from which the offset should be extracted. If this option is not used, the script tries to extract from LogReversePTPSlave_<domain_number>.txt.


[TimedSDN project]: http://tx.technion.ac.il/~dew/TimedSDN.html
