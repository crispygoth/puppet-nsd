#
class nsd (
  $conf_dir                = $::nsd::params::conf_dir,
  $group                   = $::nsd::params::group,
  $manage_control          = $::nsd::params::manage_control,
  $manage_package          = $::nsd::params::manage_package,
  $package_name            = $::nsd::params::package_name,
  $service_name            = $::nsd::params::service_name,
  # Below map to global configuration parameters
  $chroot                  = undef,
  $control_cert_file       = $::nsd::params::control_cert_file,
  $control_enable          = $::nsd::params::control_enable,
  $control_interface       = undef,
  $control_key_file        = $::nsd::params::control_key_file,
  $control_port            = undef,
  $database                = undef,
  $do_ip4                  = undef,
  $do_ip6                  = undef,
  $hide_version            = undef,
  $identity                = undef,
  $ip_address              = undef,
  $ip_transparent          = undef,
  $ipv4_edns_size          = undef,
  $ipv6_edns_size          = undef,
  $log_time_ascii          = undef,
  $logfile                 = undef,
  $nsid                    = undef,
  $pidfile                 = undef,
  $port                    = undef,
  $reuseport               = undef,
  $round_robin             = undef,
  $rrl_ipv4_prefix_length  = undef,
  $rrl_ipv6_prefix_length  = undef,
  $rrl_ratelimit           = undef,
  $rrl_size                = undef,
  $rrl_slip                = undef,
  $rrl_whitelist_ratelimit = undef,
  $server_cert_file        = $::nsd::params::server_cert_file,
  $server_count            = undef,
  $server_key_file         = $::nsd::params::server_key_file,
  $statistics              = undef,
  $tcp_count               = undef,
  $tcp_query_count         = undef,
  $tcp_timeout             = undef,
  $username                = $::nsd::params::username,
  $verbosity               = undef,
  $version                 = undef,
  $xfrd_reload_timeout     = undef,
  $xfrdfile                = undef,
  $xfrdir                  = undef,
  $zonefiles_check         = undef,
  $zonefiles_write         = undef,
  $zonelistfile            = undef,
  $zonesdir                = $::nsd::params::zonesdir,
) inherits ::nsd::params {

  validate_absolute_path($conf_dir)
  validate_string($group)
  validate_bool($manage_control)
  validate_string($package_name)
  validate_string($service_name)

  if $manage_control and ($control_cert_file != $::nsd::params::control_cert_file or $control_key_file != $::nsd::params::control_key_file or $server_cert_file != $::nsd::params::server_cert_file or $server_key_file != $::nsd::params::server_key_file) {
    fail('')
  }
  if $chroot {
    validate_absolute_path($chroot)
  }
  if $control_cert_file {
    validate_absolute_path($control_cert_file)
  }
  if $control_enable {
    validate_bool($control_enable)
  }
  if $control_interface {
    validate_ip_address_array($control_interface)
  }
  if $control_key_file {
    validate_absolute_path($control_key_file)
  }
  if $control_port {
    validate_integer($control_port, 65535, 0)
  }
  if $database {
    validate_absolute_path($database)
  }
  if $do_ip4 {
    validate_bool($do_ip4)
  }
  if $do_ip6 {
    validate_bool($do_ip6)
  }
  if $hide_version {
    validate_bool($hide_version)
  }
  validate_string($identity)
  if $ip_address {
    validate_array($ip_address)
    $_unused = validate_nsd_acl($ip_address)
  }
  if $ip_transparent {
    validate_bool($ip_transparent)
  }
  if $ipv4_edns_size {
    validate_integer($ipv4_edns_size, '', 0)
  }
  if $ipv6_edns_size {
    validate_integer($ipv6_edns_size, '', 0)
  }
  if $log_time_ascii {
    validate_bool($log_time_ascii)
  }
  if $logfile {
    validate_absolute_path($logfile)
  }
  validate_string($nsid)
  if $pidfile {
    validate_absolute_path($pidfile)
  }
  if $port {
    validate_integer($port, 65535, 0)
  }
  if $reuseport {
    validate_bool($reuseport)
  }
  if $round_robin {
    validate_bool($round_robin)
  }
  if $rrl_ipv4_prefix_length {
    validate_integer($rrl_ipv4_prefix_length, 32, 0)
  }
  if $rrl_ipv6_prefix_length {
    validate_integer($rrl_ipv6_prefix_length, 128, 0)
  }
  if $rrl_ratelimit {
    validate_integer($rrl_ratelimit, '', 0)
  }
  if $rrl_size {
    validate_integer($rrl_size, '', 0)
  }
  if $rrl_slip {
    validate_integer($rrl_slip, 2, 0)
  }
  if $rrl_whitelist_ratelimit {
    validate_integer($rrl_whitelist_ratelimit, '', 0)
  }
  if $server_cert_file {
    validate_absolute_path($server_cert_file)
  }
  if $server_count {
    validate_integer($server_count)
  }
  if $server_key_file {
    validate_absolute_path($server_key_file)
  }
  if $statistics {
    validate_integer($statistics, '', 0)
  }
  if $tcp_count {
    validate_integer($tcp_count, '', 0)
  }
  if $tcp_query_count {
    validate_integer($tcp_query_count, '', 0)
  }
  if $tcp_timeout {
    validate_integer($tcp_timeout, '', 0)
  }
  validate_string($username)
  if $verbosity {
    validate_integer($verbosity, '', 0)
  }
  validate_string($version)
  if $xfrd_reload_timeout {
    validate_integer($xfrd_reload_timeout)
  }
  if $xfrdfile {
    validate_absolute_path($xfrdfile)
  }
  if $xfrdir {
    validate_absolute_path($xfrdir)
  }
  if $zonefiles_check {
    validate_bool($zonefiles_check)
  }
  if $zonefiles_write {
    validate_integer($zonefiles_write, '', 0)
  }
  if $zonelistfile {
    validate_absolute_path($zonelistfile)
  }
  if $zonesdir {
    validate_absolute_path($zonesdir)
  }

  include ::nsd::install
  include ::nsd::config
  include ::nsd::service

  anchor { 'nsd::begin': }
  anchor { 'nsd::end': }

  Anchor['nsd::begin'] -> Class['::nsd::install'] ~> Class['::nsd::config']
    ~> Class['::nsd::service'] -> Anchor['nsd::end']
}
