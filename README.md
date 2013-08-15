Support
=======

Issues have been disabled for this repository.  
Any issues with this cookbook should be raised here:

[https://github.com/rcbops/chef-cookbooks/issues](https://github.com/rcbops/chef-cookbooks/issues)

Please title the issue as follows:

[collectd-graphite]: \<short description of problem\>

In the issue description, please include a longer description of the issue, along with any relevant log/command/error output.  
If logfiles are extremely long, please place the relevant portion into the issue description, and link to a gist containing the entire logfile

Please see the [contribution guidelines](CONTRIBUTING.md) for more information about contributing to this cookbook.

Description
===========

installs collectd client/server and configures it to forward to graphite

http://graphite.wikidot.com/

Requirements
============

Chef 0.10.0 or higher required (for Chef environment use)

Platform
--------

 * CentOS >= 6.3
 * Ubuntu >= 12.04

Cookbooks
---------

The following cookbooks are dependencies:

 * collectd
 * collectd-plugins
 * monitoring
 * osops-utils

Attributes
==========

 * node["collectd"]["services"]["network-listener"]["network"] - Control what network segment the listener listens on (default management)

Usage
=====

 * recipe[collectd-graphite::collectd-listener] will install a collectd server and configure it to forward metrics to graphite for visualisation
 * recipe[collectd-graphite::collectd-client] will install the collectd agent

TODO
====

This cookbook currently doesn't have very rich topology concepts.  It doesn't
support multicast, it doesn't support a hierarchical topology, etc.

It should.

License and Author
==================

Author:: Justin Shepherd (<justin.shepherd@rackspace.com>)  
Author:: Jason Cannavale (<jason.cannavale@rackspace.com>)  
Author:: Ron Pedde (<ron.pedde@rackspace.com>)  
Author:: Joseph Breu (<joseph.breu@rackspace.com>)  
Author:: William Kelly (<william.kelly@RACKSPACE.COM>)  
Author:: Darren Birkett (<Darren.Birkett@rackspace.co.uk>)  
Author:: Evan Callicoat (<evan.callicoat@RACKSPACE.COM>)  
Author:: Matt Thompson (<matt.thompson@rackspace.co.uk>)  

Copyright 2012-2013, Rackspace US, Inc.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
