require 'spec_helper'

describe 'validate_nsd_acl' do
  it { expect { should run.with_params(123) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([123]) }.to raise_error(/Requires either an array or string to work with/) }
  it { expect { should run.with_params([]) }.to raise_error(/Requires an array with at least 1 element/) }
  it { expect { should run.with_params('invalid') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params(['invalid']) }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params('invalid@5678') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params(['invalid@5678']) }.to raise_error(/is not a valid IP address/) }
  it { should run.with_params('1.2.3.4').and_return([]) }
  it { should run.with_params('1.2.3.4@5678').and_return([]) }
  it { should run.with_params(['1.2.3.4']).and_return([]) }
  it { should run.with_params(['1.2.3.4@5678']).and_return([]) }
  it { should run.with_params('dead::beef').and_return([]) }
  it { should run.with_params('dead::beef@5678').and_return([]) }
  it { should run.with_params(['dead::beef']).and_return([]) }
  it { should run.with_params(['dead::beef@5678']).and_return([]) }

  it { expect { should run.with_params('1.2.3.4/24') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params('dead::beef/64') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params('1.2.3.4&255.255.255.0') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params('dead::beef&ffff:ffff:ffff:ffff::') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params('1.2.3.4-5.6.7.8') }.to raise_error(/is not a valid IP address/) }
  it { expect { should run.with_params('dead::beef-feed::beef') }.to raise_error(/is not a valid IP address/) }

  it { should run.with_params('1.2.3.4/24', [], [], true).and_return([]) }
  it { should run.with_params('1.2.3.4/0', [], [], true).and_return([]) }
  it { should run.with_params('dead::beef/64', [], [], true).and_return([]) }
  it { should run.with_params('dead::beef/0', [], [], true).and_return([]) }
  it { expect { should run.with_params('1.2.3.4/33', [], [], true) }.to raise_error(/is not a valid IP\/Prefix pair/) }
  it { expect { should run.with_params('dead::beef/129', [], [], true) }.to raise_error(/is not a valid IP\/Prefix pair/) }

  it { should run.with_params('1.2.3.4&255.255.255.0', [], [], true).and_return([]) }
  it { should run.with_params('dead::beef&ffff:ffff:ffff:ffff::', [], [], true).and_return([]) }
  it { expect { should run.with_params('1.2.3.4&256.255.255.255', [], [], true) }.to raise_error(/is not a valid IP\/Mask pair/) }
  it { expect { should run.with_params('dead::beef&fffg:ffff:ffff:ffff::', [], [], true) }.to raise_error(/is not a valid IP\/Mask pair/) }

  it { should run.with_params('1.2.3.4-5.6.7.8', [], [], true).and_return([]) }
  it { should run.with_params('dead::beef-feed::beef', [], [], true).and_return([]) }
  it { expect { should run.with_params('5.6.7.8-1.2.3.4', [], [], true) }.to raise_error(/is not a valid IP address range/) }
  it { expect { should run.with_params('feed::beef-dead::beef', [], [], true) }.to raise_error(/is not a valid IP address range/) }
  it { expect { should run.with_params('dead::beef-1.2.3.4', [], [], true) }.to raise_error(/is not a valid IP address range/) }
  it { expect { should run.with_params('1.2.3.4-dead::beef', [], [], true) }.to raise_error(/is not a valid IP address range/) }

  it { should run.with_params(['1.2.3.4 NOKEY']).and_return(['NOKEY']) }
  it { should run.with_params(['1.2.3.4 NOKEY', '5.6.7.8 NOKEY']).and_return(['NOKEY']) }
  it { should run.with_params(['1.2.3.4 test'], ['NOKEY']).and_return(['test']) }
  it { expect { should run.with_params(['1.2.3.4'], ['NOKEY']) }.to raise_error(/A TSIG key is expected/) }
  it { should run.with_params(['1.2.3.4 NOKEY'], ['NOKEY']).and_return([]) }

  it { expect { should run.with_params(['AXFR 1.2.3.4 NOKEY'], ['NOKEY']) }.to raise_error(/Unknown option "AXFR"/) }
  it { expect { should run.with_params(['AXFR 1.2.3.4 NOKEY'], ['NOKEY'], ['IXFR']) }.to raise_error(/Unknown option "AXFR"/) }
  it { should run.with_params(['AXFR 1.2.3.4 NOKEY'], ['NOKEY'], ['AXFR']).and_return([]) }
end
