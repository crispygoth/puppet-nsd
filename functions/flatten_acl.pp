# Flatten an ACL type to its string form.
#
# @param value The ACL to flatten.
#
# @return [String] The flattened string.
#
# @example
#   nsd::flatten_acl(['127.0.0.1', 'NOKEY'])
#
# @since 2.0.0
function nsd::flatten_acl(Variant[NSD::ACL::AllowNotify, NSD::ACL::Notify, NSD::ACL::ProvideXFR, NSD::ACL::RequestXFR] $value) {

  $value ? {
    undef   => undef,
    default => type($value) ? {
      Type[NSD::ACL::Notify]     => type($value[0]) ? {
        Type[Tuple] => "${value[0][0]}@${value[0][1]} ${value[1]}",
        default     => "${value[0]} ${value[1]}",
      },
      Type[NSD::ACL::RequestXFR] => type($value[1]) ? {
        Type[Tuple] => "${value[0]} ${value[1][0]}@${value[1][1]} ${value[2]}",
        default     => "${value[0]} ${value[1]} ${value[2]}",
      },
      default                    => type($value[0]) ? {
        Type[Tuple] => type($value[0][1]) ? {
          Type[Bodgitlib::Port] => "${value[0][0]}@${value[0][1]} ${value[1]}",
          default               => size($value[0]) ? {
            2       => type($value[0][1]) ? {
              Type[Bodgitlib::Netmask] => "${value[0][0]}&${value[0][1]} ${value[1]}",
              default                  => "${value[0][0]}-${value[0][1]} ${value[1]}",
            },
            default => type($value[0][1]) ? {
              Type[Bodgitlib::Netmask] => "${value[0][0]}&${value[0][1]}@${value[0][2]} ${value[1]}",
              default                  => "${value[0][0]}-${value[0][1]}@${value[0][2]} ${value[1]}",
            },
          },
        },
        default     => "${value[0]} ${value[1]}",
      },
    },
  }
}
