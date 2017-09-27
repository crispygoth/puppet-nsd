require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::acl::allownotify', type: :class do
    describe 'accepts allow-notify ACLs' do
      [
        ['127.0.0.1/8', 'key.example.com.'],
        ['127.0.0.1/8', 'NOKEY'],
        [['127.0.0.1/8', 5300], 'BLOCKED'],
        ['::1', 'key.example.com.'],
        [['192.0.2.1', '192.0.2.2'], 'NOKEY'],
        [['192.0.2.1', '192.0.2.2', 5300], 'NOKEY'],
        [['192.0.2.0', '255.255.255.0'], 'BLOCKED'],
        [['192.0.2.0', '255.255.255.0', 5300], 'BLOCKED'],
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
        ['invalid', '127.0.0.1', 'key.example.com.'],
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
