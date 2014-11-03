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
    staging::file { 'unifi_sysvinit_all.deb':
      source => "http://www.ubnt.com/downloads/unifi/${version}/unifi_sysvinit_all.deb",
    }

    package { 'unifi':
      ensure   => 'installed',
      source   => '/opt/staging/unifi/unifi_sysvinit_all.deb',
      provider => 'dpkg',
      require  => [ Staging::File['unifi_sysvinit_all.deb'],Class['mongodb::server'] ],
    }
  }


  service { 'unifi':
    ensure  => 'running',
    pattern => '.*/usr/lib/unifi/lib/ace.jar.*$',
    require => Package['unifi'],
  }

  include mongodb::client

  class { 'mongodb::globals':
    manage_package_repo => true,
  }
  class { 'mongodb::server':
      verbose => true,
  }

}
