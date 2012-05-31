Description
===========

installs collectd client/server and configures it to forward to graphite (http://graphite.wikidot.com/)

Requirements
============

Ubuntu 12.04 (Precise)

Opscode "apt" cookbook
"collectd" cookbook
"collectd-plugins" cookbook
"graphite" cookbook


Usage
=====

recipe[collectd-graphite::collectd-listener] will install a collectd server and configure it to forward metrics to graphite for visualisation
recipe[collectd-graphite::collectd-client] will install the collectd agent

