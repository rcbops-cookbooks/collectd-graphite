#
# Cookbook Name:: graphite
# Recipe:: collectd-client
#
# Copyright 2012, Rackspace Hosting
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# This recipe installs a collectd client, forwarding to a collectd server

include_recipe "osops-utils"
include_recipe "collectd"
include_recipe "collectd-plugins::syslog"
include_recipe "collectd-plugins::cpu"
include_recipe "collectd-plugins::df"
include_recipe "collectd-plugins::disk"
include_recipe "collectd-plugins::interface"
include_recipe "collectd-plugins::memory"
include_recipe "collectd-plugins::swap"
collectd_plugin "load"

# We don't have great ability right now to do hierarchical topology,
# so we'll just assume we're reporting to the graphite server.
#
# FIXME: get heirarchical topologies working.
servers = [ get_access_endpoint("graphite","collectd","network-listener")["host"] ]

collectd_plugin "network" do
  options :server => servers
end
