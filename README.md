# nsd

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-nsd.svg?branch=master)](https://travis-ci.org/bodgit/puppet-nsd)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-nsd/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-nsd?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/nsd.svg)](https://forge.puppetlabs.com/bodgit/nsd)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-nsd.svg)](https://gemnasium.com/bodgit/puppet-nsd)

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with nsd](#setup)
    * [What nsd affects](#what-nsd-affects)
    * [Beginning with nsd](#beginning-with-nsd)
4. [Usage - Configuration options and additional functionality](#usage)
    * [Classes and Defined Types](#classes-and-defined-types)
        * [Class: nsd](#class-nsd)
        * [Defined Type: nsd::key](#defined-type-nsdkey)
        * [Defined Type: nsd::pattern](#defined-type-nsdpattern)
        * [Defined Type: nsd::zone](#defined-type-nsdzone)
    * [Functions](#functions)
        * [Function: validate_nsd_acl](#function-validate_nsd_acl)
    * [Examples](#examples)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

This module manages NSD.

## Module Description

This module can install the NSD packages, manage the main configuration
file and service, and manage any zone files.

## Setup

On RHEL/CentOS platforms you will need to enable the EPEL repository first.

### What nsd affects

* The package providing the NSD software.
* The `nsd.conf` configuration file.
* The service controlling the NSD daemon.
* Any zone files where the host is configured as master.

### Beginning with nsd

```puppet
include ::nsd

if $::osfamily == 'RedHat' {
  include ::epel

  Class['::epel'] -> Class['::nsd']
}
```

## Usage

### Classes and Defined Types

#### Class: `nsd`

**Parameters within `nsd`:**

##### `conf_dir`

The base configuration directory, usually either `/etc/nsd` or `/var/nsd/etc`.

##### `group`

The primary group of the dedicated user used to run NSD.

##### `manage_control`

Whether to use `nsd-control-setup` to create the remote control certificates
and keys.

##### `manage_package`

Whether to manage a package or not. Some operating systems have NSD as part of
the base system.

##### `package_name`

The name of the package to install that provides the NSD software.

##### `service_name`

The name of the service managing the NSD daemon.

##### `chroot`

Directory to chroot to on startup.

##### `control_cert_file`

Path to the control client certificate file.

##### `control_enable`

Whether to enable remote control.

##### `control_interface`

Array of interfaces to listen on for remote control requests.

##### `control_key_file`

Path to the control client key file.

##### `control_port`

Port to listen on for remote control requests.

##### `database`

Used to store compiled zone information.

##### `do_ip4`

Listen to IPv4 connections.

##### `do_ip6`

Listen to IPv6 connections.

##### `hide_version`

Prevent NSD from replying with the string.

##### `identity`

Returns this specified identity when asked.

##### `ip_address`

Array of interfaces to listen on for DNS requests.

##### `ip_transparent`

Allows NSD to bind to non-local addresses.

##### `ipv4_edns_size`

Preferred EDNS buffer size for IPv4.

##### `ipv6_edns_size`

Preferred EDNS buffer size for IPv6.

##### `log_time_ascii`

Log time in ASCII.

##### `logfile`

Log messages to this file.

##### `nsid`

Add this to the EDNS section when queried with an NSID EDNS enabled packet.

##### `pidfile`

Path to PID file.

##### `port`

Default port to listen on for DNS requests.

##### `reuseport`

Use the `SO_REUSEPORT` socket option.

##### `round_robin`

Enable round robin rotation of records in answers.

##### `rrl_ipv4_prefix_length`

IPv4 prefix length used for grouping addresses.

##### `rrl_ipv6_prefix_length`

IPv6 prefix length used for grouping addresses.

##### `rrl_ratelimit`

Maximum queries per second rate from a query source.

##### `rrl_size`

Tune size of hash table.

##### `rrl_slip`

Controls the number of packets discarded before NSD sends back a SLIP response.

##### `rrl_whitelist_ratelimit`

Maximum queries per second rate for query types that are whitelisted.

##### `server_cert_file`

Path to the control server certificate file.

##### `server_count`

Start this many NSD servers.

##### `server_key_file`

Path to the control server key file.

##### `statistics`

How often to dump statistics.

##### `tcp_count`

Maximum number of concurrent TCP connections.

##### `tcp_query_count`

Maximum number of queries served by a single TCP connection.

##### `tcp_timeout`

Overrides the default TCP timeout.

##### `username`

Dedicated user used to run NSD.

##### `verbosity`

Verbosity level for non-debug logging.

##### `version`

Override the version returned in queries.

##### `xfrd_reload_timeout`

How long to wait after a zone transfer before reloading.

##### `xfrdfile`

State file used for zone transfers.

##### `xfrdir`

Directory used to store zone transfers before processing.

##### `zonefiles_check`

Make NSD check the mtime of zone files on start and reload.

##### `zonefiles_write`

How often to write slave zones to disk.

##### `zonelistfile`

File used to store dynamically added zones.

##### `zonesdir`

Directory used for writing zone files to. Within this directory will be
`master` and `slave` directories.

#### Defined Type: `nsd::key`

**Parameters within `nsd::key`:**

##### `name`

The name of the key.

##### `algorithm`

One of `hmac-md5`, `hmac-sha1` or `hmac-sha256`.

##### `secret`

The Base64-encoded key secret.

#### Defined Type: `nsd::pattern`

**Parameters within `nsd::pattern`:**

##### `name`

The name of the pattern.

##### `allow_notify`

Array of ACL entries for servers allowed to send notifies to this server. Any
TSIG keys specified will add a dependency relationship that requires an
[`nsd::key`](#defined-type-nsdkey) matching that name.

##### `allow_axfr_fallback`

Whether to fallback to using AXFR if zone transfer by IXFR failed.

##### `notifies`

Array of ACL entries for servers that are sent notifies from this server. Any
TSIG keys specified will add a dependency relationship that requires an
[`nsd::key`](#defined-type-nsdkey) matching that name.

##### `notify_retry`

Number of retries when sending notifies.

##### `outgoing_interface`

ACL specifying the interface used to send notifies or request a zone transfer.

##### `provide_xfr`

Array of ACL entries for servers that are allowed to request a zone transfer
from this server. Any TSIG keys specified will add a dependency relationship
that requires an [`nsd::key`](#defined-type-nsdkey) matching that name.

##### `request_xfr`

Array of ACL entries for servers that are used to request a zone transfer. Any
TSIG keys specified will add a dependency relationship that requires an
[`nsd::key`](#defined-type-nsdkey) matching that name.

##### `rrl_whitelist`

Array of query types to whitelist from rate limiting.

##### `zonestats`

The name of the group where statistics are added to.

#### Defined Type: `nsd::zone`

**Parameters within `nsd::zone`:**

##### `name`

The name of the zone which should be a proper domain name.

##### `content`

Content for the zone file, same as for a normal `file` resource.

##### `source`

A source URI for the zone file, same as for a normal `file` resource.

##### `allow_notify`

Array of ACL entries for servers allowed to send notifies to this server. Any
TSIG keys specified will add a dependency relationship that requires an
[`nsd::key`](#defined-type-nsdkey) matching that name.

##### `allow_axfr_fallback`

Whether to fallback to using AXFR if zone transfer by IXFR failed.

##### `include_pattern`

The name of a previously defined pattern to include. It is included before any
other zone setting to allow any setting to be overridden. It will also add a
dependency relationship that requires an
[`nsd::pattern`](#defined-type-nsdpattern) with this name.

##### `notifies`

Array of ACL entries for servers that are sent notifies from this server. Any
TSIG keys specified will add a dependency relationship that requires an
[`nsd::key`](#defined-type-nsdkey) matching that name.

##### `notify_retry`

Number of retries when sending notifies.

##### `outgoing_interface`

ACL specifying the interface used to send notifies or request a zone transfer.

##### `provide_xfr`

Array of ACL entries for servers that are allowed to request a zone transfer
from this server. Any TSIG keys specified will add a dependency relationship
that requires an [`nsd::key`](#defined-type-nsdkey) matching that name.

##### `request_xfr`

Array of ACL entries for servers that are used to request a zone transfer. Any
TSIG keys specified will add a dependency relationship that requires an
[`nsd::key`](#defined-type-nsdkey) matching that name.

##### `rrl_whitelist`

Array of query types to whitelist from rate limiting.

##### `zonestats`

The name of the group where statistics are added to.

### Functions

#### Function: `validate_nsd_acl`

Validate an array of ACL entries returning an array of any TSIG key names
found in the entries. An optional second parameter specifies any values that
should not be taken as TSIG key names. An optional third parameter specifies
any optional values that can appear before the IP address field. An optional
final boolean parameter specifies whether just single IP addresses are
accepted (the default) or CIDR, IP & Netmask and IP - IP ranges are also
accepted.

~~~
validate_nsd_acl(['1.2.3.4 test'], ['NOKEY'])
validate_nsd_acl(['AXFR 1.2.3.0/24@5353 test'], ['NOKEY'], ['AXFR'], true)
~~~

### Examples

Configure NSD listening on all interfaces with a single master zone:

```puppet
include ::nsd

::nsd::zone { 'example.com':
  source => 'puppet:///modules/example/example.com.zone',
}
```

Update the above example to allow zone transfers from other machines on the
same network protected with the given TSIG key:

```puppet
include ::nsd

::nsd::key { 'example':
  algorithm => 'hmac-sha256',
  secret    => '6z+8iKRIQrwN43TFfO/Rf2NHzpHIFVi6PsJ7dDESclc=',
}

::nsd::zone { 'example.com':
  source => 'puppet:///modules/example/example.com.zone',
  provide_xfr => [
    "${::network}&${::netmask} example",
    "${::network6}&${::netmask6} example",
  ],
}
```

Configure NSD listening on the primary interface only as a slave for a single
zone protected with the given TSIG key:

```puppet
class { '::nsd':
  ip_address => [
    $::ipaddress,
    $::ipaddress6,
  ],
}

::nsd::key { 'example':
  algorithm => 'hmac-sha256',
  secret    => '6z+8iKRIQrwN43TFfO/Rf2NHzpHIFVi6PsJ7dDESclc=',
}

::nsd::zone { 'example.com':
  allow_notify => [
    '192.0.2.1 example',
  ],
  request_xfr  => [
    'AXFR 192.0.2.1 example',
  ],
}
```

Update NSD to slave more than one zone and make use of a pattern to simplify
the configuration:

```puppet
class { '::nsd':
  ip_address => [
    $::ipaddress,
    $::ipaddress6,
  ],
}

::nsd::key { 'example':
  algorithm => 'hmac-sha256',
  secret    => '6z+8iKRIQrwN43TFfO/Rf2NHzpHIFVi6PsJ7dDESclc=',
}

::nsd::pattern { 'example':
  allow_notify => [
    '192.0.2.1 example',
  ],
  request_xfr  => [
    'AXFR 192.0.2.1 example',
  ],
}

::nsd::zone { 'example.com':
  include_pattern => 'example',
}

::nsd::zone { 'example.org':
  include_pattern => 'example',
}
```

## Reference

### Classes

#### Public Classes

* [`nsd`](#class-nsd): Main class for managing NSD.

#### Private Classes

* `nsd::install`: Handles NSD installation.
* `nsd::config`: Handles NSD configuration.
* `nsd::params`: Different configuration data for different systems.
* `nsd::service`: Manages the `nsd` service.

### Defined Types

#### Public Defined Types

* [`nsd::key`](#defined-type-nsdkey): Handles defining TSIG keys.
* [`nsd::pattern`](#defined-type-nsdpattern): Handles defining
  patterns.
* [`nsd::zone`](#defined-type-nsdzone): Handles defining zones.

### Functions

* [`validate_nsd_acl`](#function-validate_nsd_acl):

## Limitations

This module exposes all of the various NSD configuration options with a couple
of exceptions:

1. Patterns cannot include other patterns nor set the zone filename. The
   first is because the patterns are written to the configuration file in
   alphabetical order and NSD wants the included pattern to be defined prior
   to being included so it avoids a source of potential errors.
2. Zones cannot set the zone filename either. This is for when the host is a
   master and so the location for the zone file is at a known location.

Any setting that accepts a boolean `yes`/`no` value also accepts native Puppet
boolean values. Any multi-valued setting accepts an array of values.

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* RedHat/CentOS Enterprise Linux 6/7
* OpenBSD 5.8/5.9

Testing on other platforms has been light and cannot be guaranteed.

## Development

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-nsd).
