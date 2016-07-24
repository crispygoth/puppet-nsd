#
class nsd::params {

  $control_enable = true
  $manage_control = true
  $service_name   = 'nsd'

  case $::osfamily {
    'RedHat': {
      $conf_dir       = '/etc/nsd'
      $group          = 'nsd'
      $manage_package = true
      $package_name   = 'nsd'
      $username       = 'nsd'
      $zonesdir       = $conf_dir
    }
    'OpenBSD': {
      $conf_dir       = '/var/nsd/etc'
      $group          = '_nsd'
      $manage_package = false
      $username       = '_nsd'
      $zonesdir       = '/var/nsd/zones'
    }
    default: {
      fail("The ${module_name} module is not supported on an ${::osfamily} based system.") # lint:ignore:80chars
    }
  }

  $control_cert_file = "${conf_dir}/nsd_control.pem"
  $control_key_file  = "${conf_dir}/nsd_control.key"
  $server_cert_file  = "${conf_dir}/nsd_server.pem"
  $server_key_file   = "${conf_dir}/nsd_server.key"
}
