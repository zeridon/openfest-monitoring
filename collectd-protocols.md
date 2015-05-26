collectd plain text protocol
============================

Full protocol spec: https://collectd.org/wiki/index.php/Plain_text_protocol

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
