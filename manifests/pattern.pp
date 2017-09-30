# Define a pattern in NSD.
#
# @example Define a pattern
#   ::nsd::pattern { 'example':
#     allow_notify => [
#       ['192.0.2.1', 'keyname.'],
#     ],
#     request_xfr  => [
#       ['192.0.2.1', 'keyname.'],
#     ],
#   }
#
# @param pattern
# @param order
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
# @see puppet_defined_types::nsd::zone ::nsd::zone
define nsd::pattern (
  String                                    $pattern             = $title,
  Variant[Integer, String]                  $order               = '10',
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

  ::concat::fragment { "nsd pattern ${pattern}":
    content => template('nsd/pattern.erb'),
    order   => "20${order}",
    target  => "${::nsd::conf_dir}/nsd.conf",
  }
}
