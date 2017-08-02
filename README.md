# papertrail

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with papertrail](#setup)
    * [What papertrail affects](#what-papertrail-affects)
    * [Beginning with papertrail](#beginning-with-papertrail)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Limitations - OS compatibility, etc.](#limitations)
5. [Development - Guide for contributing to the module](#development)

## Description

This module configures the Papertrail [remote_syslog2](https://github.com/papertrail/remote_syslog2) agent. To configure `rsyslog` for use with Papertrail, check out the [Papertrail documentation](http://help.papertrailapp.com/kb/configuration/configuring-remote-syslog-from-unixlinux-and-bsdos-x/).

## Setup

### What `papertrail` affects

This module installs and manages the Papertrail `remote_syslog2` agent via the Github releases.

### Beginning with `papertrail`

Set the parameters `$papertrail::destination_host`, `$papertrail::destination_port`, and at least one file/directory in `$papertrail::files`.

```ruby
class {'papertrail':
  destination_host => 'logsN.papertrailapp.com',
  destination_port => XXXXX,
  files            => ['/tmp/test.log', '/srv/foo.txt', '/var/log/*.bar']
}
```

## Usage

This module only has one manifest, which does all setup and configuration. There are a number of parameters you can configure, all of which mirror the configuration items found in the `remote_syslog2` [README](https://github.com/papertrail/remote_syslog2#configuration).

- `$papertrail::files`

  **Type:** Array

  A list of files or patterns to send to Papertrail. At least one entry is required.

  Example:
  ```ruby
    class {'papertrail':
      files => [
        '/tmp/test.log',
        '/srv/foo.txt',
        '/var/log/*.bar'
      ]
    }
  ```

  To tag a file/path, the structure is slightly different:
  ```ruby
    class {'papertrail':
      files => [
        '/tmp/test.log',
        '/srv/foo.txt',
        '/var/log/*.bar',
        {'path' => '/srv/foo.txt', 'tag' => 'my_tag'}
      ]
    }
   ```

- `$papertrail::exclude_files`

  **Type:** Array

  A list of files or patterns to exclude.

  Example:
  ```ruby
    class {'papertrail':
      exclude_files => [
        '/tmp/exlude.log',
        '/srv/dont-include.log',
        '/var/log/skip-me.log'
      ]
    }
  ```

- `$papertrail::exclude_patterns`

  **Type:** Array

  A regex of log message patterns to exclude.

  Example:
  ```ruby
    class {'papertrail':
      exclude_patterns => ['\d+ things']
    }
  ```
- `$papertrail::hostname`

  **Type:** String

  Override the default hostname.

  Example:
  ```ruby
    class {'papertrail':
      hostname => 'my-super-awesome-hostname'
    }
  ```

- `$papertrail::destination_host`, `$papertrail::destination_port`, & `$papertrail::destination_protocol`

  **Type:** String (except `$destination_port`, which is **Integer**)

  The Papertrail host and port to send logs to, and the protocol to use. These are required. Destination and port default to empty, while Protocol defaults to `tls`.

  Example:
  ```ruby
    class {'papertrail':
      destination_host     => 'logsN.papertrailapp.com',
      destination_port     => XXXXX,
      destination_protocol => 'tls'
    }
  ```

- `$papertrail::new_file_check_interval`

  **Type:** Integer

  Overrides the default file check interval.

  Example:
  ```ruby
    class {'papertrail':
      new_file_check_interval => 30
    }
  ```

- `$papertrail::severity`

  **Type:** String

  Overrides the default `remote_syslog2` severity level.

  Example:
  ```ruby
    class {'papertrail':
      severity => 'warn'
    }
  ```

- `$papertrail::facility`

  **Type:** String

  Overrides the default `remote_syslog2` facility.

  Example:
  ```ruby
    class {'papertrail':
      facility => 'local7'
    }
  ```

- `$papertrail::version`

  **Type:** String

  Use a different version of `remote_syslog` than the default.

  Example:
  ```ruby
    class {'papertrail':
      version => '0.18'
    }
  ```


## Limitations

### Supported Platforms

* RHEL 6 / CentOS 6
* RHEL 7 / CentOS 7
* Amazon Linux 2017.03
* Ubuntu 14.04
* Ubuntu 16.04

Debian 9 is currently unsupported due to [upstream issues](https://tickets.puppetlabs.com/browse/PA-1079).

### Supported Puppet Versions

This module has been tested on Puppet 4.x and 5.x and 4.x.

## Development

### Testing

Integration tests utilize `kitchen-puppet` and `serverspec`. To run the test suite:

1. Run `bundle install`
2. Run `kitchen test`

Style and syntax tests can be run with:

* `puppet-lint manifests/*`
* `puppet parser validate manifests/*`

No unit tests have been written at this time.

All contributions must pass the tests above.

`spec/fixtures/manifests/site.pp` contains the configuration for testing.

#### Testing Amazon Linux

Testing Amazon Linux through `test-kitchen` requires a bit more setup:

1. Ensure `kitchen-ec2` is installed: `gem install kitchen-ec2`
2. Update `.kitchen.yml` to have the correct AWS key ID you're going to use
3. Set `security_group_ids` in the driver section to include a security group accessible from your laptop. Not setting this will use the `default`    security group.
4. Set `transport.ssh_key` to the path of your SSH key. It looks for `id_rsa` by default.

## Release Notes/Contributors/Etc.

**License:** See [LICENSE](LICENSE.md)

**Author:** Mike Julian (@mjulian)
