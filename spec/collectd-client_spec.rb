require 'chefspec'

describe 'collectd-graphite::collectd-client' do
  ['debian', 'rhel'].each do |pf|
    ['osops-utils', 'collectd'].each do |rcp|
      it "should, on platform family #{pf}, include recipe #{rcp}" do
        chef_run = ChefSpec::ChefRunner.new() do |node|
          node.automatic_attrs['platform_family'] = pf
          node.automatic_attrs["chef_packages"]["chef"]["version"] = 11
          node.set['solo']['graphite']['collectd']['network-listener'][
            'host' => '1.2.3.4'
          ]
        end
        chef_run.converge(described_recipe)
        expect(chef_run).to include_recipe rcp
      end
    end

    it "should, on platform family #{pf}, update monitoring configs"\
      "attr if node does not include role[collectd-server]" do
        chef_run = ChefSpec::ChefRunner.new() do |node|
          node.automatic_attrs['platform_family'] = pf
          node.automatic_attrs["chef_packages"]["chef"]["version"] = 11
          node.set['solo']['graphite']['collectd']['network-listener'][
            'host' => '1.2.3.4'
          ]
        end
        chef_run.converge(described_recipe)
        expect(chef_run.node['monitoring']['configs']).to(
          include("/etc/collectd/plugins/network.conf")
        )
    end

    it "should, on platform family #{pf}, create plugin.conf file"\
      "if node does not include role[collectd-server]" do
        chef_run = ChefSpec::ChefRunner.new() do |node|
          node.automatic_attrs['platform_family'] = pf
          node.automatic_attrs["chef_packages"]["chef"]["version"] = 11
          node.set['solo']['graphite']['collectd']['network-listener'][
            'host' => '1.2.3.4'
          ]
        end
        chef_run.converge(described_recipe)
        filepath = "/etc/collectd/plugins/network.conf"
        expect(chef_run).to create_file filepath
        file = chef_run.template(filepath)
        expect(file).to be_owned_by('root', 'root')
        expect(file.mode).to eq('644')
    end

    it "should, on platform family #{pf}, not update monitoring configs"\
      " attr if node includes role[collectd-server]" do
        chef_run = ChefSpec::ChefRunner.new() do |node|
          node.automatic_attrs['platform_family'] = pf
          node.automatic_attrs["chef_packages"]["chef"]["version"] = 11
          node.set['solo']['graphite']['collectd']['network-listener'][
            'host' => '1.2.3.4'
          ]
          Chef::Config[:role_path] = './spec/roles'
        end
      chef_run.converge('role[collectd-server]', described_recipe)
      expect(chef_run.node['monitoring']['configs']).not_to(
        include("/etc/collectd/plugins/network.conf")
      )
      expect(chef_run.node['monitoring']['configs']).to eq([])
    end

    it "should, on platform family #{pf}, not create plugin.conf"\
      " file if node does not include role[collectd-server]" do
        chef_run = ChefSpec::ChefRunner.new() do |node|
          node.automatic_attrs['platform_family'] = pf
          node.automatic_attrs["chef_packages"]["chef"]["version"] = 11
          node.set['solo']['graphite']['collectd']['network-listener'][
            'host' => '1.2.3.4'
          ]
          Chef::Config[:role_path] = './spec/roles'
        end
        chef_run.converge('role[collectd-server]', described_recipe)
        filepath = "/etc/collectd/plugins/network.conf"
        expect(chef_run).not_to create_file filepath
    end
  end
end
