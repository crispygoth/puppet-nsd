# Installs and configures NSD.
#
# @example Declaring the class
#   include ::nsd
#
# @param conf_dir
# @param group
# @param manage_control
# @param manage_package
# @param package_name
# @param service_name
# @param chroot
# @param control_cert_file
# @param control_enable
# @param control_interface
# @param control_key_file
# @param control_port
# @param database
# @param do_ip4
# @param do_ip6
# @param hide_version
# @param identity
# @param ip_address
# @param ip_transparent
# @param ipv4_edns_size
# @param ipv6_edns_size
# @param log_time_ascii
# @param logfile
# @param nsid
# @param pidfile
# @param port
# @param reuseport
# @param round_robin
# @param rrl_ipv4_prefix_length
# @param rrl_ipv6_prefix_length
# @param rrl_ratelimit
# @param rrl_size
# @param rrl_slip
# @param rrl_whitelist_ratelimit
# @param server_cert_file
# @param server_count
# @param server_key_file
# @param statistics
# @param tcp_count
# @param tcp_query_count
# @param tcp_timeout
# @param username
# @param verbosity
# @param version
# @param xfrd_reload_timeout
# @param xfrdfile
# @param xfrdir
# @param zonefiles_check
# @param zonefiles_write
# @param zonelistfile
# @param zonesdir
#
# @see puppet_defined_types::nsd::key ::nsd::key
# @see puppet_defined_types::nsd::pattern ::nsd::pattern
# @see puppet_defined_types::nsd::zone ::nsd::zone
class nsd (
  Stdlib::Absolutepath                      $conf_dir                = $::nsd::params::conf_dir,
  String                                    $group                   = $::nsd::params::group,
  Boolean                                   $manage_control          = $::nsd::params::manage_control,
  Boolean                                   $manage_package          = $::nsd::params::manage_package,
  Optional[String]                          $package_name            = $::nsd::params::package_name,
  String                                    $service_name            = $::nsd::params::service_name,
  # Below map to global configuration parameters
  Optional[Stdlib::Absolutepath]            $chroot                  = undef,
  Optional[Stdlib::Absolutepath]            $control_cert_file       = $::nsd::params::control_cert_file,
  Optional[Boolean]                         $control_enable          = $::nsd::params::control_enable,
  Optional[Array[IP::Address::NoSubnet, 1]] $control_interface       = undef,
  Optional[Stdlib::Absolutepath]            $control_key_file        = $::nsd::params::control_key_file,
  Optional[Bodgitlib::Port]                 $control_port            = undef,
  Optional[Stdlib::Absolutepath]            $database                = undef,
  Optional[Boolean]                         $do_ip4                  = undef,
  Optional[Boolean]                         $do_ip6                  = undef,
  Optional[Boolean]                         $hide_version            = undef,
  Optional[String]                          $identity                = undef,
  Optional[Array[NSD::Interface, 1]]        $ip_address              = undef,
  Optional[Boolean]                         $ip_transparent          = undef,
  Optional[Integer[0]]                      $ipv4_edns_size          = undef,
  Optional[Integer[0]]                      $ipv6_edns_size          = undef,
  Optional[Boolean]                         $log_time_ascii          = undef,
  Optional[Stdlib::Absolutepath]            $logfile                 = undef,
  Optional[String]                          $nsid                    = undef,
  Optional[Stdlib::Absolutepath]            $pidfile                 = undef,
  Optional[Bodgitlib::Port]                 $port                    = undef,
  Optional[Boolean]                         $reuseport               = undef,
  Optional[Boolean]                         $round_robin             = undef,
  Optional[Integer[0, 32]]                  $rrl_ipv4_prefix_length  = undef,
  Optional[Integer[0, 128]]                 $rrl_ipv6_prefix_length  = undef,
  Optional[Integer[0]]                      $rrl_ratelimit           = undef,
  Optional[Integer[0]]                      $rrl_size                = undef,
  Optional[Integer[0]]                      $rrl_slip                = undef,
  Optional[Integer[0]]                      $rrl_whitelist_ratelimit = undef,
  Optional[Stdlib::Absolutepath]            $server_cert_file        = $::nsd::params::server_cert_file,
  Optional[Integer[1]]                      $server_count            = undef,
  Optional[Stdlib::Absolutepath]            $server_key_file         = $::nsd::params::server_key_file,
  Optional[Integer[0]]                      $statistics              = undef,
  Optional[Integer[0]]                      $tcp_count               = undef,
  Optional[Integer[0]]                      $tcp_query_count         = undef,
  Optional[Integer[0]]                      $tcp_timeout             = undef,
  Optional[String]                          $username                = $::nsd::params::username,
  Optional[Integer[0, 3]]                   $verbosity               = undef,
  Optional[String]                          $version                 = undef,
  Optional[Integer[-1]]                     $xfrd_reload_timeout     = undef,
  Optional[Stdlib::Absolutepath]            $xfrdfile                = undef,
  Optional[Stdlib::Absolutepath]            $xfrdir                  = undef,
  Optional[Boolean]                         $zonefiles_check         = undef,
  Optional[Integer[0]]                      $zonefiles_write         = undef,
  Optional[Stdlib::Absolutepath]            $zonelistfile            = undef,
  Optional[Stdlib::Absolutepath]            $zonesdir                = $::nsd::params::zonesdir,
) inherits ::nsd::params {

  if $manage_control and ($control_cert_file != $::nsd::params::control_cert_file or $control_key_file != $::nsd::params::control_key_file or $server_cert_file != $::nsd::params::server_cert_file or $server_key_file != $::nsd::params::server_key_file) {
    fail('Cannot have $manage_control enabled with non-standard locations for remote control keys and/or certificates')
  }

  contain ::nsd::install
  contain ::nsd::config
  contain ::nsd::service

  Class['::nsd::install'] ~> Class['::nsd::config'] ~> Class['::nsd::service']
}
