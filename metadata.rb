maintainer       "Rackspace Hosting"
maintainer_email "osops@lists.launchpad.net"
license          "Apache 2.0"
description      "glues collectd and graphite cookbooks together"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"
depends          "apt"
depends          "apache2"
depends          "collectd"
depends          "collectd-plugins"
depends          "graphite"
depends          "osops-utils"

