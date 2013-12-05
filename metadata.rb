name             "collectd-graphite"
maintainer       "Rackspace US, Inc."
maintainer_email "osops@lists.launchpad.net"
license          "Apache 2.0"
description      "glues collectd and graphite cookbooks together"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          IO.read(File.join(File.dirname(__FILE__), 'VERSION'))

%W{ centos ubuntu }.each do |distro|
  supports distro
end

%W{ collectd collectd-plugins monitoring osops-utils }.each do |dep|
  depends dep
end
