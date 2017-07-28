require 'serverspec'
set :backend, :exec
set :path, '/usr/local/bin:$PATH'

describe file('/usr/local/bin/remote_syslog') do
  it { should exist }
end

describe command('remote_syslog') do
  its(:exit_status) { should eq 0 }
end

describe service('remote_syslog') do
  it { should be_running }
  it { should be_enabled }
end

describe file('/etc/log_files.yml') do
  it { should exist }
  its(:content_as_yaml) do
    should include(
      'files' => ['/tmp/test.log', '/srv/foo.txt', '/var/log/*.bar',
                  include('path' => '/srv/foo.txt', 'tag' => 'foo_file')],
      'exclude_files' => ['/tmp/exlude.log', '/srv/dont-include.log', '/var/log/skip-me.log'],
      # 'exclude_patterns' => ["\d+ things"],
      'hostname' => 'my-super-awesome-hostname',
      'destination' => include(
        'host' => 'testhost.papertrail',
        'port' => 6500,
        'protocol' => 'tls'
      ),
      'new_file_check_interval' => 30
    )
  end
end
