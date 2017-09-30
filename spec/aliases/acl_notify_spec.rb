require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::acl::notify', type: :class do
    describe 'accepts notify ACLs' do
      [
        ['127.0.0.1', 'key.example.com.'],
        ['127.0.0.1', 'NOKEY'],
        [['127.0.0.1', 5300], 'NOKEY'],
        ['::1', 'key.example.com.'],
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
        ['256.0.0.1', 'key.example.com.'],
        ['127.0.0.1', 'key.example.com'],
        [['127.0.0.1', 65536], 'NOKEY'],
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
