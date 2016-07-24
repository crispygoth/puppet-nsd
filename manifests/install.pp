#
class nsd::install {

  if $::nsd::manage_package {
    package { $::nsd::package_name:
      ensure => present,
    }
  }
}
