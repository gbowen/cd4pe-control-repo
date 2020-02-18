# Class: profile::dev_host
#
#
class profile::dev_host {

  class {'awscli':
    version => 'latest',
  }

}
