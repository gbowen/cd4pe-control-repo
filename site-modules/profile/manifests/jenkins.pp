#
class profile::jenkins {
  class { '::jenkins':
    version            => '2.204.2',
    service_enable     => false,
    configure_firewall => true,
    executors          => $::processors['count'],
  }

  include ::profile::jenkins::plugins

  include ::profile::base

  include ::profile::nginx

    # Create basic firewall rules
  firewall { '100 allow http access':
    dport  => 80,
    proto  => tcp,
    action => accept,
  }

  firewall { '104 allow puppet-pxp access':
    dport  => 8142,
    proto  => tcp,
    action => accept,
  }

  # Include a reverse proxy in front
  nginx::resource::server { $::hostname:
    listen_port    => 80,
    listen_options => 'default_server',
    proxy          => 'http://localhost:8080',
  }

  # Set Jenkins' default shell to bash
  file { 'jenkins_default_shell':
    ensure  => file,
    path    => '/var/lib/jenkins/hudson.tasks.Shell.xml',
    source  => 'puppet:///modules/profile/hudson.tasks.Shell.xml',
    notify  => Service['jenkins'],
    require => Package['jenkins'],
  }

  # Create a user in the Puppet console for Jenkins
  @@console::user { 'jenkins':
    password     => fqdn_rand_string(20, '', 'jenkins'),
    display_name => 'Jenkins',
    roles        => ['Developers'],
  }

  # Create the details for the Puppet token
  $token = console::user::token('jenkins')
  $secret_json = epp('profile/jenkins_secret_text.json.epp',{
    'id'          => 'PE-Deploy-Token',
    'description' => 'Puppet Enterprise Token',
    'secret'      => $token,
  })
  $secret_json_escaped = shell_escape($secret_json)

  # If the token has been generated then create it
  # if $token {
  #   jenkins_credentials { 'PE-Deploy-Token':
  #     impl        => 'StringCredentialsImpl',
  #     secret      => $token,
  #     description => 'Puppet Enterprise Token',
  #   }
  # }
}
