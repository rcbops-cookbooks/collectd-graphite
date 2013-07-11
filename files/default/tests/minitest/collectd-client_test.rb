require_relative './support/helpers'

describe_recipe 'collectd-graphite::collectd-client' do
  include CollectdGraphiteTestHelpers

  conf_file = '/etc/collectd/plugins/network.conf'

  it 'should create network.conf' do
    file(conf_file).must_exist
  end

  it 'should set permissions on network.conf to 644' do
    file(conf_file).must_have(:mode, '644')
  end

  it 'should set user and group to root' do
    file(conf_file).must_have(:owner, 'root').with(:group, 'root')
  end
end
