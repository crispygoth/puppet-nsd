# @since 2.0.0
type NSD::ACL::RequestXFR = Variant[
  Tuple[
    Enum['AXFR', 'UDP'],
    NSD::Interface,
    Variant[Bodgitlib::Zone::NonRoot, Enum['NOKEY']]
  ],
  NSD::ACL::Notify
]
