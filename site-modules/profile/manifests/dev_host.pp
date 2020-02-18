# Class: profile::dev_host
#
#
class profile::dev_host {

  class {'awscli':
    version => 'latest',
  }

  firewall { '102 allow puppet access':
    dport  => 8140,
    proto  => tcp,
    action => accept,
  }

}
