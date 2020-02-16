#
class role::puppet_master {
  include ::profile::base
  include ::profile::compile::master
}
