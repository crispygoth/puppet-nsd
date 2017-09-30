require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::rrltype', type: :class do
    describe 'accepts RRL types' do
      [
        'nxdomain',
        'error',
        'referral',
        'any',
        'rrsig',
        'wildcard',
        'nodata',
        'dnskey',
        'positive',
        'all',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile }
        end
      end
    end
    describe 'rejects other values' do
      [
        1,
        'invalid',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
