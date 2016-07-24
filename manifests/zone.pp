#
define nsd::zone (
  $content             = undef,
  $source              = undef,
  $allow_notify        = undef,
  $allow_axfr_fallback = undef,
  $include_pattern     = undef,
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

  if ! is_domain_name($name) {
    fail("'${name}' is not a valid domain name.")
  }
  if $content and $source {
    fail("You must provide either 'content' or 'source', they are mutually exclusive") # lint:ignore:80chars
  }
  validate_string($content)
  validate_string($source)
  if $allow_notify {
    validate_array($allow_notify)
    $_allow_notify_keys = validate_nsd_acl($allow_notify, ['NOKEY', 'BLOCKED'], [], true)
  }
  if $allow_axfr_fallback {
    validate_bool($allow_axfr_fallback)
  }
  validate_string($include_pattern)
  if $notifies {
    validate_array($notifies)
    $_notifies_keys = validate_nsd_acl($notifies, ['NOKEY'], [])
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
  }
  if $request_xfr {
    validate_array($request_xfr)
    $_request_xfr_keys = validate_nsd_acl($request_xfr, ['NOKEY'], ['AXFR', 'UDP'])
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

  $_name = "nsd zone ${name}"

  if $content or $source {
    $zonefile = "master/${name}.zone"

    file { "${::nsd::zonesdir}/${zonefile}":
      ensure       => file,
      owner        => 0,
      group        => 0,
      mode         => '0644',
      content      => $content,
      source       => $source,
      validate_cmd => "/usr/sbin/nsd-checkzone ${name} %",
      before       => ::Concat::Fragment[$_name],
    }
  } else {
    $zonefile = "slave/${name}.zone"
  }

  ::concat::fragment { $_name:
    content => template('nsd/zone.erb'),
    order   => "30-${name}",
    target  => "${::nsd::conf_dir}/nsd.conf",
  }

  if size($keys) > 0 {
    Nsd::Key[$keys] -> ::Concat::Fragment[$_name]
  }

  if $include_pattern {
    Nsd::Pattern[$include_pattern] -> ::Concat::Fragment[$_name]
  }
}
