node default {
  class {'papertrail':
    destination_host        => 'testhost.papertrail',
    destination_port        => 6500,
    destination_protocol    => 'tls',
    files                   => [
      '/tmp/test.log', '/srv/foo.txt', '/var/log/*.bar', {'path' => '/srv/foo.txt', 'tag' => 'foo_file'}
    ],
    exclude_files           => [
      '/tmp/exlude.log', '/srv/dont-include.log', '/var/log/skip-me.log'
    ],
    hostname                => 'my-super-awesome-hostname',
    exclude_patterns        => ['\d+ things'],
    new_file_check_interval => 30,
    severity                => 'warn',
    facility                => 'local7'
  }
}
