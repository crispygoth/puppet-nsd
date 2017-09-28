require 'spec_helper'

describe 'nsd::flatten_acl' do
  it { should run.with_params(['127.0.0.1', 'NOKEY']).and_return('127.0.0.1 NOKEY') }
  it { should run.with_params([['127.0.0.1', 5300], 'keyname.']).and_return('127.0.0.1@5300 keyname.') }
  it { should run.with_params(['AXFR', '::1', 'NOKEY']).and_return('AXFR ::1 NOKEY') }
  it { should run.with_params(['UDP', ['::1', 5300], 'keyname.']).and_return('UDP ::1@5300 keyname.') }
  it { should run.with_params(['127.0.0.0/8', 'BLOCKED']).and_return('127.0.0.0/8 BLOCKED') }
  it { should run.with_params([['127.0.0.0/8', 5300], 'NOKEY']).and_return('127.0.0.0/8@5300 NOKEY') }
  it { should run.with_params([['127.0.0.1', '127.0.0.2'], 'keyname.']).and_return('127.0.0.1-127.0.0.2 keyname.') }
  it { should run.with_params([['127.0.0.0', '255.0.0.0'], 'keyname.']).and_return('127.0.0.0&255.0.0.0 keyname.') }
  it { should run.with_params([['127.0.0.0', '255.0.0.0', 5300], 'BLOCKED']).and_return('127.0.0.0&255.0.0.0@5300 BLOCKED') }
  it { expect { should run.with_params([]) }.to raise_error(/parameter 'value' /) }
  it { expect { should run.with_params('invalid') }.to raise_error(/parameter 'value' /) }
end
