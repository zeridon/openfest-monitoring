How to use this
===============

The tools provided here are to be used for monitoring of OpenFest related infrastructure.

Current Tools
=============
`wlstats-gather.sh` - prototype wireless statistics gatherer for collectd infrastructure

Tools Usage
===========

wlstats-gather.sh
-----------------
This is intended to be used as an exec plugin for collectd. As such collectd and it's exec plugin are mandatory.

Please note: Although possible to load collectd plugin multiple times it is not advisable. For best results load a plugin only once

```
LoadPlugin exec
<Plugin exec>
	Exec "username:groupname" "/path/to/wlstats-gather.sh"
</Plugin>
```

Please note:
 * if username:groupname combo is ommitted you have no guarantees on the permissions the user that will execute the plugin will have.

Full example
============
Central collector (server)
--------------------------

```
Hostname central-collectd
FQDNLookup false

# how often data will come ... do not change once set
Interval 60

# timeouts and load optimization
Timeout 5
#ReadThreads 5
#WriteThreads 5

# logging
LoadPlugin syslog
<Plugin syslog>
	LogLevel info
</Plugin>

# now start listening on network / UDP (25826)
LoadPlugin network
<Plugin Network>
	Listen "0.0.0.0"
	ReportStats true
</Plugin>

# and let's save the data
LoadPlugin rrdtool
<Plugin rrdtool>
	DataDir /srv/metrics/collectd/rrd
	# can lead to some data loss
	CreateFilesAsync true
</Plugin>
```

AP (client) sending metrics
---------------------------

```
Hostname AP-left-1
FQDNLookup false

Interval 60

# timeouts and load optimization
Timeout 5
#ReadThreads 5
#WriteThreads 5

# logging
LoadPlugin syslog
<Plugin syslog>
	LogLevel info
</Plugin>

# Sending to network / UDP (25826)
LoadPlugin network
<Plugin Network>
	Server "central-collectd"
</Plugin>

# some mtrics to collect ...
LoadPlugin exec
<Plugin exec>
	Exec "nobody" "/mon/wlstats-gather.sh"
</Plugin>
```
