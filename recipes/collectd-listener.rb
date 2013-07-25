#
# Cookbook Name:: graphite
# Recipe:: collectd-listener
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

# This recipe installs a collectd server, listening on a network socket,
# and forwarding to graphite
#

include_recipe "osops-utils"
include_recipe "collectd"
include_recipe "monitoring"

if platform_family?('rhel')
  pkg_name = "libcurl-devel"
  plugin_dir = "/usr/lib64/collectd"
elsif platform_family?('debian')
  pkg_name = "libcurl3-gnutls"
  plugin_dir = "/usr/lib/collectd"
end

package pkg_name do
  action :install
end

collectd_listener_endpoint = get_bind_endpoint("collectd", "network-listener")
if not Chef::Config[:solo]
  line_receiver_endpoint = get_access_endpoint(
    "graphite", "carbon", "line-receiver")
else
  line_receiver_endpoint = node['solo']['graphite']['carbon']['line-receiver']
end

monitoring_metric "carbon_writer" do
  type "pyscript"
  script "carbon_writer.py"
  options "LineReceiverHost" => line_receiver_endpoint["host"],
    "LineReceiverPort" => line_receiver_endpoint["port"],
    "TypesDB" => "/usr/share/collectd/types.db",
    "DifferentiateCountersOverTime" => true,
    "LowercaseMetricNames" => true,
    "MetricPrefix" => "collectd"
end

cookbook_file "#{plugin_dir}/carbon_writer.py" do
  source "carbon_writer.py"
  mode "0755"
  owner "root"
  group "root"
  notifies :restart, 'service[collectd]', :delayed
end

include_recipe "collectd-plugins::syslog"
include_recipe "collectd-plugins::cpu"
include_recipe "collectd-plugins::df"
include_recipe "collectd-plugins::disk"
include_recipe "collectd-plugins::interface"
include_recipe "collectd-plugins::memory"
include_recipe "collectd-plugins::swap"
collectd_plugin "load"

collectd_plugin "network" do
  options :listen => collectd_listener_endpoint["host"]
end

graphite_endpoint = get_bind_endpoint("graphite", "api")

# this creates an ordering problem
#collectd_plugin "apache" do
#  template "apache_plugin.conf.erb"
#  cookbook "graphite"
#  options :instances => { "graphite" => { :url => "http://#{graphite_endpoint['host']}:#{graphite_endpoint['port']}/server-status?auto" }}
#end
