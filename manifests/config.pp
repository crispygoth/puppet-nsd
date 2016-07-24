#
class nsd::config {

  $conf_dir                = $::nsd::conf_dir
  $group                   = $::nsd::group
  $chroot                  = $::nsd::chroot
  $control_cert_file       = $::nsd::control_cert_file
  $control_enable          = $::nsd::control_enable
  $control_interface       = $::nsd::control_interface
  $control_key_file        = $::nsd::control_key_file
  $control_port            = $::nsd::control_port
  $database                = $::nsd::database
  $do_ip4                  = $::nsd::do_ip4
  $do_ip6                  = $::nsd::do_ip6
  $hide_version            = $::nsd::hide_version
  $identity                = $::nsd::identity
  $ip_address              = $::nsd::ip_address
  $ip_transparent          = $::nsd::ip_transparent
  $ipv4_edns_size          = $::nsd::ipv4_edns_size
  $ipv6_edns_size          = $::nsd::ipv6_edns_size
  $log_time_ascii          = $::nsd::log_time_ascii
  $logfile                 = $::nsd::logfile
  $nsid                    = $::nsd::nsid
  $pidfile                 = $::nsd::pidfile
  $port                    = $::nsd::port
  $reuseport               = $::nsd::reuseport
  $round_robin             = $::nsd::round_robin
  $rrl_ipv4_prefix_length  = $::nsd::rrl_ipv4_prefix_length
  $rrl_ipv6_prefix_length  = $::nsd::rrl_ipv6_prefix_length
  $rrl_ratelimit           = $::nsd::rrl_ratelimit
  $rrl_size                = $::nsd::rrl_size
  $rrl_slip                = $::nsd::rrl_slip
  $rrl_whitelist_ratelimit = $::nsd::rrl_whitelist_ratelimit
  $server_cert_file        = $::nsd::server_cert_file
  $server_count            = $::nsd::server_count
  $server_key_file         = $::nsd::server_key_file
  $statistics              = $::nsd::statistics
  $tcp_count               = $::nsd::tcp_count
  $tcp_query_count         = $::nsd::tcp_query_count
  $tcp_timeout             = $::nsd::tcp_timeout
  $username                = $::nsd::username
  $verbosity               = $::nsd::verbosity
  $version                 = $::nsd::version
  $xfrd_reload_timeout     = $::nsd::xfrd_reload_timeout
  $xfrdfile                = $::nsd::xfrdfile
  $xfrdir                  = $::nsd::xfrdir
  $zonefiles_check         = $::nsd::zonefiles_check
  $zonefiles_write         = $::nsd::zonefiles_write
  $zonelistfile            = $::nsd::zonelistfile
  $zonesdir                = $::nsd::zonesdir

  case $::osfamily { # lint:ignore:case_without_default
    'RedHat': {
      file { '/etc/sysconfig/nsd':
        ensure => absent,
      }
    }
  }

  file { $zonesdir:
    ensure       => directory,
    owner        => 0,
    group        => 0,
    mode         => '0644',
    force        => true,
    purge        => true,
    recurse      => true,
    recurselimit => 1,
  }

  if $conf_dir != $zonesdir {
    file { $conf_dir:
      ensure       => directory,
      owner        => 0,
      group        => $group,
      mode         => '0640',
      force        => true,
      purge        => true,
      recurse      => true,
      recurselimit => 1,
    }
  }

  ::concat { "${conf_dir}/nsd.conf":
    owner        => 0,
    group        => $group,
    mode         => '0640',
    warn         => "# !!! Managed by Puppet !!!\n\n",
    validate_cmd => '/usr/sbin/nsd-checkconf %',
  }

  ::concat::fragment { 'nsd server':
    content => template('nsd/server.erb'),
    order   => '01',
    target  => "${conf_dir}/nsd.conf",
  }

  if $::nsd::manage_control {
    $control_files = [
      $control_cert_file,
      $control_key_file,
      $server_cert_file,
      $server_key_file,
    ]

    exec { 'nsd-control-setup':
      path    => $::path,
      creates => $control_files,
    }

    file { $control_files:
      ensure  => file,
      owner   => 0,
      group   => $group,
      mode    => '0640',
      require => Exec['nsd-control-setup'],
    }
  }

  file { "${zonesdir}/master":
    ensure       => directory,
    owner        => 0,
    group        => 0,
    mode         => '0644',
    force        => true,
    purge        => true,
    recurse      => true,
    recurselimit => 1,
  }

  file { "${zonesdir}/slave":
    ensure => directory,
    owner  => 0,
    group  => $group,
    mode   => '0664',
  }
}
