require 'spec_helper'

module ChefSpec
  module Matchers
    define_resource_matchers([:measure], [:monitoring_metric], :name)
  end
end

platforms = ['ubuntu', 'centos']
platform_families = {
  'ubuntu' => 'debian',
  'centos' => 'rhel'
}
rcps = ["osops-utils", "collectd", "monitoring", "collectd-plugins::syslog",
  "collectd-plugins::cpu", "collectd-plugins::df", "collectd-plugins::disk",
  "collectd-plugins::interface", "collectd-plugins::memory",
  "collectd-plugins::swap"]

describe 'collectd-graphite::collectd-listener' do
  platforms.each do |pltfrm|
    let(:chef_run) {
      chef_run = ChefSpec::ChefRunner.new do |node|
        node.automatic_attrs['platform'] = pltfrm
        node.automatic_attrs['platform_family'] = platform_families[pltfrm]
        node.set["chef_packages"]["chef"]["version"] = 11
        node.set['solo']['collectd']['network-listener'] = {
          'host'=> '1.2.3.4'
        }
        node.set['solo']['graphite']['carbon']['line-receiver'] = {
          'host'=> '1.2.3.4',
          'port'=> '1234'
        }
        Chef::Recipe.any_instance.stub(:get_access_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
        Chef::Recipe.any_instance.stub(:get_bind_endpoint).and_return(
          {
            'host' => '1.2.3.4',
            'port' => '80'
          }
        )
      end
      chef_run.converge described_recipe
    }
    rcps.each do |rcp|
      it "should, for #{pltfrm}, include #{rcp}" do
        expect(chef_run).to include_recipe rcp
      end
    end

    it "should install the correct libcurl package on #{pltfrm}" do
      if chef_run.node['platform_family'].include?('rhel')
        pkg = 'libcurl-devel'
      elsif chef_run.node['platform_family'].include?('debian')
        pkg = 'libcurl3-gnutls'
      end
      expect(chef_run).to install_package pkg
    end

    it "should create carbon_writer.py on #{pltfrm}" do
      if chef_run.node['platform_family'].include?('rhel')
        fp = '/usr/lib64/collectd/carbon_writer.py'
      elsif chef_run.node['platform_family'].include?('debian')
        fp = '/usr/lib/collectd/carbon_writer.py'
      end
      expect(chef_run).to create_cookbook_file fp
      file = chef_run.cookbook_file(fp)
      expect(file).to be_owned_by('root', 'root')
      expect(file.mode).to eq('0755')
    end

    it "should configure monitoring on #{pltfrm}" do
      expect(chef_run).to measure_monitoring_metric 'carbon_writer'
    end

    ['load', 'network'].each do |plugin|
      it "should, on platform #{pltfrm}, update monitoring"\
        " configs attr for #{plugin} plugin" do
          expect(chef_run.node['monitoring']['configs']).to(
            include("/etc/collectd/plugins/#{plugin}.conf")
          )
      end

      it "should, on platform #{pltfrm}, create #{plugin}.conf file" do
        filepath = "/etc/collectd/plugins/#{plugin}.conf"
        expect(chef_run).to create_file filepath
        file = chef_run.template(filepath)
        expect(file).to be_owned_by('root', 'root')
        expect(file.mode).to eq('644')
      end
    end
  end
end
