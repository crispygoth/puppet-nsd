require 'spec_helper'

if Puppet::Util::Package.versioncmp(Puppet.version, '4.4.0') >= 0
  describe 'test::interface', type: :class do
    describe 'accepts interfaces' do
      [
        '127.0.0.1',
        ['127.0.0.1', 53],
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
        '127.0.0.256',
        ['127.0.0.1', 65536],
      ].each do |value|
        describe value.inspect do
          let(:params) {{ value: value }}
          it { is_expected.to compile.and_raise_error(/parameter 'value' /) }
        end
      end
    end
  end
end
