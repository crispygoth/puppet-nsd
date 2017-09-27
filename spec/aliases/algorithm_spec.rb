require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::algorithm', type: :class do
    describe 'accepts algorithms' do
      [
        'hmac-md5',
        'hmac-sha1',
        'hmac-sha224',
        'hmac-sha256',
        'hmac-sha384',
        'hmac-sha512',
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
        'hmac-invalid',
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
