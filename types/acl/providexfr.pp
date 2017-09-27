# @since 2.0.0
type NSD::ACL::ProvideXFR = Variant[
  Tuple[
    Variant[IP::Address, Tuple[IP::Address, Bodgitlib::Port]],
    Variant[Bodgitlib::Zone::NonRoot, Enum['NOKEY', 'BLOCKED']]
  ],
  Tuple[
    Tuple[IP::Address::NoSubnet, Variant[IP::Address::NoSubnet, Bodgitlib::Netmask], Bodgitlib::Port, 2],
    Variant[Bodgitlib::Zone::NonRoot, Enum['NOKEY', 'BLOCKED']]
  ]
]
