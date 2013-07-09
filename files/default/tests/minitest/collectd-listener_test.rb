require_relative './support/helpers'

describe_recipe 'collectd-graphite::collectd-listener' do
  include CollectdGraphiteTestHelpers

  it 'should install libcurl package' do
    if ['centos', 'fedora', 'redhat'].include?(node['platform'])
      pkg = 'libcurl-devel'
    elsif ['debian', 'ubuntu'].include?(node['platform'])
      pkg = 'libcurl3-gnutls'
    end
    package(pkg).must_be_installed
  end

  ['load', 'network'].each do |plugin|
    conf_file = "/etc/collectd/plugins/#{plugin}.conf"

    it "should create #{plugin}.conf" do
      file(conf_file).must_exist
    end

    it "should set permissions on #{plugin}.conf to 644" do
      file(conf_file).must_have(:mode, '644')
    end

    it "should set user and group to root on #{plugin}.conf" do
      file(conf_file).must_have(:owner, 'root').with(:group, 'root')
    end
  end

  it "should create carbon_writer.py" do
    if ['centos', 'fedora', 'redhat'].include?(node['platform'])
      script = '/usr/lib64/collectd/carbon_writer.py'
    elsif ['debian', 'ubuntu'].include?(node['platform'])
      script = '/usr/lib/collectd/carbon_writer.py'
    end
    file(script).must_exist
  end

  it "should set permissions on carbon_writer.py to 644" do
    if ['centos', 'fedora', 'redhat'].include?(node['platform'])
      script = '/usr/lib64/collectd/carbon_writer.py'
    elsif ['debian', 'ubuntu'].include?(node['platform'])
      script = '/usr/lib/collectd/carbon_writer.py'
    end
    file(script).must_have(:mode, '0755')
  end

  it "should set user and group to root on carbon_writer.py" do
    if ['centos', 'fedora', 'redhat'].include?(node['platform'])
      script = '/usr/lib64/collectd/carbon_writer.py'
    elsif ['debian', 'ubuntu'].include?(node['platform'])
      script = '/usr/lib/collectd/carbon_writer.py'
    end
    file(script).must_have(:owner, 'root').with(:group, 'root')
  end
end
