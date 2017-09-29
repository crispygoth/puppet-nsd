# Define a zone in NSD.
#
# @example Create a master zone
#   ::nsd::zone { 'example.com.':
#     source => 'puppet:///data/example.com.zone',
#   }
#
# @example Create a slave zone that accepts notifies from the master
#   ::nsd::zone { 'example.com.':
#     allow_notify => [
#       ['192.0.2.1', 'NOKEY'],
#     ],
#     request_xfr  => [
#       ['192.0.2.1', 'NOKEY'],
#     ],
#   }
#
# @param zone
# @param content
# @param source
# @param allow_notify
# @param allow_axfr_fallback
# @param include_pattern
# @param notifies
# @param notify_retry
# @param outgoing_interface
# @param provide_xfr
# @param request_xfr
# @param rrl_whitelist
# @param zonestats
#
# @see puppet_classes::nsd ::nsd
# @see puppet_defined_types::nsd::key ::nsd::key
# @see puppet_defined_types::nsd::pattern ::nsd::pattern
define nsd::zone (
  Bodgitlib::Zone                           $zone                = $title,
  Optional[String]                          $content             = undef,
  Optional[String]                          $source              = undef,
  Optional[Array[NSD::ACL::AllowNotify, 1]] $allow_notify        = undef,
  Optional[Boolean]                         $allow_axfr_fallback = undef,
  Optional[String]                          $include_pattern     = undef,
  Optional[Array[NSD::ACL::Notify, 1]]      $notifies            = undef, # Renamed to avoid clash with notify metaparameter
  Optional[Integer[0]]                      $notify_retry        = undef,
  Optional[NSD::Interface]                  $outgoing_interface  = undef,
  Optional[Array[NSD::ACL::ProvideXFR, 1]]  $provide_xfr         = undef,
  Optional[Array[NSD::ACL::RequestXFR, 1]]  $request_xfr         = undef,
  Optional[Array[NSD::RRLType, 1]]          $rrl_whitelist       = undef,
  Optional[String]                          $zonestats           = undef,
) {

  if ! defined(Class['::nsd']) {
    fail('You must include the nsd base class before using any nsd defined resources')
  }

  if $content and $source {
    fail("You must provide either 'content' or 'source', they are mutually exclusive")
  }

  $_allow_notify = $allow_notify ? {
    undef   => undef,
    default => delete_undef_values($allow_notify.map |$acl| { nsd::flatten_acl($acl) }),
  }

  $_notifies = $notifies ? {
    undef   => undef,
    default => delete_undef_values($notifies.map |$acl| { nsd::flatten_acl($acl) }),
  }

  $_provide_xfr = $provide_xfr ? {
    undef   => undef,
    default => delete_undef_values($provide_xfr.map |$acl| { nsd::flatten_acl($acl) }),
  }

  $_request_xfr = $request_xfr ? {
    undef   => undef,
    default => delete_undef_values($request_xfr.map |$acl| { nsd::flatten_acl($acl) }),
  }

  $_title = "nsd zone ${zone}"

  $_filename = $zone[-1] ? {
    '.'     => "${zone[0, -2]}.zone",
    default => "${zone}.zone",
  }

  if $content or $source {
    $zonefile = "master/${_filename}"

    file { "${::nsd::zonesdir}/${zonefile}":
      ensure       => file,
      owner        => 0,
      group        => 0,
      mode         => '0644',
      content      => $content,
      source       => $source,
      validate_cmd => "/usr/sbin/nsd-checkzone ${zone} %",
      before       => ::Concat["${::nsd::conf_dir}/nsd.conf"],
    }
  } else {
    $zonefile = "slave/${_filename}"
  }

  ::concat::fragment { $_title:
    content => template("${module_name}/zone.erb"),
    order   => '30',
    target  => "${::nsd::conf_dir}/nsd.conf",
  }
}
