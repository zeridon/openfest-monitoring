collectd plain text protocol
============================

We are interested in submitting data (either to local or remote collectd)

PUTVAL <Identifier> [<OptionList>] Valuelist

Identifier
host "/" plugin ["-" plugin instance] "/" type ["-" type instance]
https://collectd.org/wiki/index.php/Identifier


Option list
 interval - interval in seconds

Value list - comma separated values

Value - timestamp:val:val (if more)

Sample:

PUTVAL "testhost/testplugin/testmetric" 12345678:123:458
