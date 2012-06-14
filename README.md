Description
===========

installs collectd client/server and configures it to forward to graphite (http://graphite.wikidot.com/)

Requirements
============

Ubuntu 12.04 (Precise)

 * Opscode "apt" cookbook
 * "collectd" cookbook
 * "collectd-plugins" cookbook
 * "graphite" cookbook

Attributes
==========

Control what network segment the listener listens on

node["collectd"]["services"]["network-listener"]["network"] (default management)

Usage
=====

recipe[collectd-graphite::collectd-listener] will install a collectd server
and configure it to forward metrics to graphite for visualisation
recipe[collectd-graphite::collectd-client] will install the collectd agent

TODO
====

This cookbook currently doesn't have very rich topology concepts.  It doesn't
support multicast, it doesn't support a hierarchical topology, etc.

It should.
