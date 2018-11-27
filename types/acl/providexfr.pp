# @since 2.0.0
type NSD::ACL::ProvideXFR = Variant[
  Tuple[
    Variant[Stdlib::IP::Address, Tuple[Stdlib::IP::Address, Stdlib::Port]],
    Variant[Bodgitlib::Zone::NonRoot, Enum['NOKEY', 'BLOCKED']]
  ],
  Tuple[
    Tuple[Stdlib::IP::Address::NoSubnet, Variant[Stdlib::IP::Address::NoSubnet, Bodgitlib::Netmask], Stdlib::Port, 2],
    Variant[Bodgitlib::Zone::NonRoot, Enum['NOKEY', 'BLOCKED']]
  ]
]
