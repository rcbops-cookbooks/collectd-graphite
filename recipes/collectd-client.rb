#
# Cookbook Name:: graphite
# Recipe:: collectd-client
#
# Copyright 2012-2013, Rackspace US, Inc.
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

# We don't have great ability right now to do hierarchical topology,
# so we'll just assume we're reporting to the graphite server.
#
# FIXME: get heirarchical topologies working.
if not Chef::Config[:solo]
  servers = [
    get_access_endpoint("graphite", "collectd", "network-listener")["host"]
  ]
else
  servers = [node['solo']['graphite']['collectd']['network-listener']['host']]
end

# ignore foodcritic FC023
# see http://tickets.opscode.com/browse/CHEF-1065
unless node["roles"].include?("collectd-server")
  collectd_plugin "network" do
    options :server => servers
  end
end
