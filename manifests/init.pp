class unifi(
  $version     = '5.6.29',
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
      require => [ Apt::Source['precise_ubiquiti'], Package['mongodb-10gen'] ],
    }
  } else {
    # Install from their downloads page
    staging::file { 'unifi_sysvinit_all.deb':
      source => "https://dl.ubnt.com/unifi/${version}/unifi_sysvinit_all.deb",
    }

    package { 'unifi':
      ensure   => 'installed',
      source   => '/opt/staging/unifi/unifi_sysvinit_all.deb',
      provider => 'dpkg',
      require  => [ Staging::File['unifi_sysvinit_all.deb'],Package['mongodb-10gen'] ],
    }
  }


  service { 'unifi':
    ensure  => 'running',
    pattern => '.*/usr/lib/unifi/lib/ace.jar.*$',
    require => Package['unifi'],
  }


  class { '::mongodb::globals':
    manage_package_repo => true,
  }

  package { 'mongodb-10gen':
    ensure => '2.4.14',
  }


}
