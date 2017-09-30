# nsd

Tested with Travis CI

[![Build Status](https://travis-ci.org/bodgit/puppet-nsd.svg?branch=master)](https://travis-ci.org/bodgit/puppet-nsd)
[![Coverage Status](https://coveralls.io/repos/bodgit/puppet-nsd/badge.svg?branch=master&service=github)](https://coveralls.io/github/bodgit/puppet-nsd?branch=master)
[![Puppet Forge](http://img.shields.io/puppetforge/v/bodgit/nsd.svg)](https://forge.puppetlabs.com/bodgit/nsd)
[![Dependency Status](https://gemnasium.com/bodgit/puppet-nsd.svg)](https://gemnasium.com/bodgit/puppet-nsd)

#### Table of Contents

1. [Description](#description)
2. [Setup - The basics of getting started with nsd](#setup)
    * [Setup requirements](#setup-requirements)
    * [Beginning with nsd](#beginning-with-nsd)
3. [Usage - Configuration options and additional functionality](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Description

This module manages NSD.

RHEL/CentOS and OpenBSD are supported using Puppet 4.6.0 or later.

## Setup

### Setup Requirements

On RHEL/CentOS platforms you will need to have access to the EPEL repository by
using [stahnma/epel](https://forge.puppet.com/stahnma/epel) or by other means.

### Beginning with nsd

In the simplest case, configure NSD as a master with a single zone:

```puppet
include ::nsd

::nsd::zone { 'example.com.':
  source => 'puppet:///modules/example/example.com.zone',
}
```

## Usage

Configure NSD listening on the primary interface only as a slave for a single zone protected with the given TSIG key:

```puppet
include ::nsd

::nsd::key { 'example.':
  algorithm => 'hmac-sha256',
  secret    => '6z+8iKRIQrwN43TFfO/Rf2NHzpHIFVi6PsJ7dDESclc=',
}

::nsd::zone { 'example.com.':
  allow_notify => [
    ['192.0.2.1', 'example.'],
  ],
  request_xfr  => [
    ['AXFR', '192.0.2.1', 'example.'],
  ],
}
```

## Reference

The reference documentation is generated with
[puppet-strings](https://github.com/puppetlabs/puppet-strings) and the latest
version of the documentation is hosted at
[https://bodgit.github.io/puppet-nsd/](https://bodgit.github.io/puppet-nsd/).

## Limitations

This module has been built on and tested against Puppet 4.6.0 and higher.

The module has been tested on:

* RedHat Enterprise Linux 6/7
* OpenBSD 6.0/6.1

## Development

The module has both [rspec-puppet](http://rspec-puppet.com) and
[beaker-rspec](https://github.com/puppetlabs/beaker-rspec) tests. Run them
with:

```
$ bundle exec rake test
$ PUPPET_INSTALL_TYPE=agent PUPPET_INSTALL_VERSION=x.y.z bundle exec rake beaker:<nodeset>
```

Please log issues or pull requests at
[github](https://github.com/bodgit/puppet-nsd).
