# Define a TSIG key in NSD.
#
# @example Configure a SHA256 TSIG key
#   ::nsd::key { 'keyname.':
#     algorithm => 'hmac-sha256',
#     secret    => '6z+8iKRIQrwN43TFfO/Rf2NHzpHIFVi6PsJ7dDESclc=',
#   }
#
# @param algorithm The TSIG key algorithm
# @param secret The Base64-encoded TSIG key secret
# @param key The name of the key
#
# @see puppet_classes::nsd ::nsd
# @see puppet_defined_types::nsd::pattern ::nsd::pattern
# @see puppet_defined_types::nsd::zone ::nsd::zone
define nsd::key (
  NSD::Algorithm           $algorithm,
  String                   $secret,
  Bodgitlib::Zone::NonRoot $key       = $title,
) {

  if ! defined(Class['::nsd']) {
    fail('You must include the nsd base class before using any nsd defined resources')
  }

  if versioncmp($::puppetversion, '4.9.0') >= 0 {
    if $secret != String(Binary($secret), '%B') {
      fail('Key secret is not Base64-encoded correctly')
    }
  }

  ::concat::fragment { "nsd key ${key}":
    content => template("${module_name}/key.erb"),
    order   => '10',
    target  => "${::nsd::conf_dir}/nsd.conf",
  }
}
