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
    require => [ Apt::Source['precise_ubiquiti'], Class['mongodb::server'] ],
  }

  service { 'unifi':
    ensure  => 'running'
    pattern => '.* /usr/lib/unifi/lib/ace.jar start$'
  }

  class { 'mongodb::globals':
    manage_package_repo => true,
  }
  class { 'mongodb::server':
      verbose => true,
  }

}
