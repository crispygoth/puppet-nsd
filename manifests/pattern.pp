#
define nsd::pattern (
  $allow_notify        = undef,
  $allow_axfr_fallback = undef,
  $notifies            = undef, # Renamed to avoid clash with notify metaparameter
  $notify_retry        = undef,
  $outgoing_interface  = undef,
  $provide_xfr         = undef,
  $request_xfr         = undef,
  $rrl_whitelist       = undef,
  $zonestats           = undef,
) {

  if ! defined(Class['::nsd']) {
    fail('You must include the nsd base class before using any nsd defined resources') # lint:ignore:80chars
  }

  validate_re($name, '^\S+$')
  if $allow_notify {
    validate_array($allow_notify)
    $_allow_notify_keys = validate_nsd_acl($allow_notify, ['NOKEY', 'BLOCKED'], [], true)
  } else {
    $_allow_notify_keys = []
  }
  if $allow_axfr_fallback {
    validate_bool($allow_axfr_fallback)
  }
  if $notifies {
    validate_array($notifies)
    $_notifies_keys = validate_nsd_acl($notifies, ['NOKEY'], [])
  } else {
    $_notifies_keys = []
  }
  if $notify_retry {
    validate_integer($notify_retry)
  }
  if $outgoing_interface {
    validate_string($outgoing_interface)
    $_unused = validate_nsd_acl($outgoing_interface)
  }
  if $provide_xfr {
    validate_array($provide_xfr)
    $_provide_xfr_keys = validate_nsd_acl($provide_xfr, ['NOKEY', 'BLOCKED'], [], true)
  } else {
    $_provide_xfr_keys = []
  }
  if $request_xfr {
    validate_array($request_xfr)
    $_request_xfr_keys = validate_nsd_acl($request_xfr, ['NOKEY'], ['AXFR', 'UDP'])
  } else {
    $_request_xfr_keys = []
  }
  if $rrl_whitelist {
    validate_array($rrl_whitelist)
  }
  validate_string($zonestats)

  $keys = unique(delete_undef_values(flatten([
    $_allow_notify_keys,
    $_notifies_keys,
    $_provide_xfr_keys,
    $_request_xfr_keys,
  ])))

  $_name = "nsd pattern ${name}"

  ::concat::fragment { $_name:
    content => template('nsd/pattern.erb'),
    order   => "20-${name}",
    target  => "${::nsd::conf_dir}/nsd.conf",
  }

  if size($keys) > 0 {
    Nsd::Key[$keys] -> ::Concat::Fragment[$_name]
  }
}
