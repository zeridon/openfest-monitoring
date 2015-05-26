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
