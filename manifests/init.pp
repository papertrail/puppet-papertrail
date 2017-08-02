# doc
class papertrail (
  Optional[Array] $files = undef,
  Optional[Array] $exclude_files = undef,
  Optional[Array] $exclude_patterns = undef,
  Optional[String] $hostname = undef,
  Integer $destination_port = undef,
  String $destination_host = undef,
  String $destination_protocol = 'tls',
  Optional[Integer] $new_file_check_interval = undef,
  Optional[String] $facility = undef,
  Optional[String] $severity = undef,
  String $version = '0.19'
) {

  case $facts['os']['family'] {
    /(RedHat|Amazon)/: {
      $full_pkg_name = "remote_syslog2-${$papertrail::version}-1.x86_64.rpm"
      $pkg_name = 'remote_syslog2'
      $pkg_provider = 'rpm'
    }
    'Debian': {
      $full_pkg_name = "remote-syslog2_${$papertrail::version}_amd64.deb"
      $pkg_name = 'remote-syslog2'
      $pkg_provider = 'dpkg'
    }
    default: { fail('Unsupported OS family') }
  }

  remote_file {"/tmp/${full_pkg_name}":
    source => "http://github.com/papertrail/remote_syslog2/releases/download/v${$papertrail::version}/${full_pkg_name}"
  }

  package {$pkg_name:
    provider => $pkg_provider,
    source   => "/tmp/${full_pkg_name}",
    require  => Remote_File["/tmp/${full_pkg_name}"]
  }

  file {'/etc/log_files.yml':
    ensure  => file,
    content => template('papertrail/log_files.yml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    notify  => Service[remote_syslog]
  }

  service {'remote_syslog':
    ensure    => running,
    enable    => true,
    subscribe => Package[$pkg_name]
  }
}
