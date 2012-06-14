#
# Cookbook Name:: graphite
# Recipe:: collectd-listener
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

# This recipe installs a collectd server, listening on a network socket,
# and forwarding to graphite
#

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


case node[:platform]
when "fedora"
  pkg_name = "libcurl-devel"
when "ubuntu", "debian"
  pkg_name = "libcurl3-gnutls"
end

package pkg_name do
  action :upgrade
end

collectd_plugin "network" do
  if node['collectd']['is_proxy']
    options :listen=>'0.0.0.0', :server=>node['collectd']['remote']['ip'], :Forward=>'True'
  else
    options :listen=>'0.0.0.0'
  end
end

collectd_plugin "syslog" do
  options :log_level => "info"
end

collectd_plugin "apache" do
  template "apache_plugin.conf.erb"
  cookbook "graphite"
  options :instances => { "graphite" => { :url => "http://localhost/server-status?auto" }}
end

cookbook_file "/usr/lib/collectd/carbon_writer.py" do
  source "carbon_writer.py"
  mode "0755"
  owner "root"
  group "root"
end

collectd_python_plugin "carbon_writer" do
  options :line_receiver_host => "0.0.0.0",
          :line_receiver_port => 2003,
          :types_d_b => "/usr/share/collectd/types.db",
          :differentiate_counters_over_time => true,
          :lowercase_metric_names => true,
          :metric_prefix => "collectd"
end
