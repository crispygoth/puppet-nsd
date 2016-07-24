#
define nsd::key (
  $algorithm,
  $secret,
) {

  if ! defined(Class['::nsd']) {
    fail('You must include the nsd base class before using any nsd defined resources') # lint:ignore:80chars
  }

  validate_re($name, '^[-a-z0-9_.]+$')
  validate_re($algorithm, '^hmac-(?:md5|sha1|sha256)$')
  validate_string($secret)
  validate_base64($secret)

  ::concat::fragment { "nsd key ${name}":
    content => template('nsd/key.erb'),
    order   => "10-${name}",
    target  => "${::nsd::conf_dir}/nsd.conf",
  }
}
