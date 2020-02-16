# Plugins with the correct version
class profile::jenkins::plugins {
  $plugins = {

  }

  $plugins.each |$name,$version| {
    jenkins::plugin { $name:
      version => $version,
    }
  }
}
