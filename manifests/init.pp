class unifi(
  $version     = '3.2.7-2347',
  $manage_repo = true,
){


  if $manage_repo {
    # Install from their repo
    apt::source { 'precise_ubiquiti':
      comment           => 'This is the ubiquiti precise 12.0.4 source',
      location          => 'http://www.ubnt.com/downloads/unifi/distros/deb/precise/',
      repos             => 'ubiquiti',
      key               => 'C0A52C50',
      key_server        => 'keyserver.ubuntu.com',
      include_src       => false,
    }
    package { 'unifi':
      ensure  => $version,
      require => [ Apt::Source['precise_ubiquiti'], Class['mongodb::server'] ],
    }
  } else {
    # Install from their downloads page
    package { 'unifi':
      ensure   => 'installed',
      require  => Class['mongodb::server'],
      source   => "http://www.ubnt.com/downloads/unifi/${version}/unifi_sysvinit_all.deb",
      provider => 'dpkg',
    }
  }


  service { 'unifi':
    ensure  => 'running',
    pattern => '.*/usr/lib/unifi/lib/ace.jar.*$',
    require => Package['unifi'],
  }

  class { 'mongodb::globals':
    manage_package_repo => true,
  }
  class { 'mongodb::server':
      verbose => true,
  }

}
