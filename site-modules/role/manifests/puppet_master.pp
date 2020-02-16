#
class role::puppet_master {
  include ::profile::base
  include ::profile::puppet_master
}
