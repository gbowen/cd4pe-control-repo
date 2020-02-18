# Class: profile::dev_host
#
#
class profile::dev_host {

  class {'awscli':
    version => 'latest',
  }

  firewall { '104 allow puppet-pxp access':
    dport  => 8142,
    proto  => tcp,
    action => accept,
  }

}
