#!/bin/sh
#
# Simple wireless statistics gatherer for collectd
#
# Description: Simple wireless statistics gatherer for collectd
# Prereqs:     OpenWRT compatible system / wlinfo / wl
# Used via:    Collectd exec plugin type
# Author:      Vladimir Vitkov <vvitkov@linux-bg.org>
# 
# Version:     0.1
# Date:        2015.05.25
#
# Changelog:   2015.05.25 - Initial version

# Variable Definition
_HOSTNAME='testhost'
_PERIOD=60 # in seconds
_PLUGIN='wlstats'

# Binaries
_iwinfo='iwinfo'
_iw='iw'

# main loop
while true ; do
	_start_time=$(date +%s)

	# do work
	for _interface in $(${_iwinfo} | grep 'ESSID' | awk '{print $1}') ; do
	#for _interface in wlan0 ; do
		# get detailed essid info and prep for send
		${_iwinfo} ${_interface} info > /var/run/${_start_time}_${_interface}
		_tx_power=$(grep 'Tx-Power' /var/run/${_start_time}_${_interface} | awk '{print $2}')
		_link_quality=$(grep 'Link Quality' /var/run/${_start_time}_${_interface} | awk '{print $6}' | cut -d'/' -f1)
		_signal=$(grep 'Signal' /var/run/${_start_time}_${_interface} | awk '{print $2}' | tr -d '-')
		_noise=$(grep 'Noise' /var/run/${_start_time}_${_interface} | awk '{print $5}' | tr -d '-')
		_bit_rate=$(grep 'Bit Rate' /var/run/${_start_time}_${_interface} | awk '{print $3}')
		_clients=$(${_iw} ${_interface} station dump | grep '^Station' | wc -l)

		# start emiting metrics
		echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/gauge-tx_power ${_start_time}:${_tx_power}"
		echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/gauge-link_quality ${_start_time}:${_link_quality}"
		echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/gauge-signal ${_start_time}:${_signal}"
		echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/gauge-noise ${_start_time}:${_noise}"
		echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/gauge-bit_rate ${_start_time}:${_bit_rate}"
		echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/gauge-clients ${_start_time}:${_clients}"

		# now let's pick up the statistics
		for _metric in $(ls -1 /sys/kernel/debug/ieee80211/*/netdev:${_interface}/../statistics/) ; do
			echo -e "PUTVAL ${_HOSTNAME}/${_PLUGIN}-${_interface}/counter-$(echo ${_metric}) ${_start_time}:$(cat /sys/kernel/debug/ieee80211/*/netdev:${_interface}/../statistics/${_metric})"
		done

		# nuke the temp file
		rm -f /var/run/${_start_time}_${_interface}
	done

	# now calculate sleep time
	_end_time=$(date +%s)
	sleep $(echo ${_PERIOD} ${_end_time} ${_start_time} | awk '{print $1 - $2 + $3 }')
done
