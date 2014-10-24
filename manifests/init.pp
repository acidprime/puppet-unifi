class unifi {
  apt::source { 'precise_ubiquiti':
    comment           => 'This is the ubiquiti precise 12.0.4 source',
    location          => 'http://www.ubnt.com/downloads/unifi/distros/deb/precise/',
    repos             => 'ubiquiti',
    key               => 'C0A52C50',
    key_server        => 'keyserver.ubuntu.com',
    include_src       => false,
  }

  package { 'unifi-rapid':
    ensure  => 'installed',
    require => [ Apt::Source['precise_ubiquiti'], Class['mongodb'] ],
  }


  service { 'unifi':
    ensure => 'running'
  }

  class { 'mongodb::globals':
    manage_package_repo => true,
  }
  include mongodb

}
