require 'spec_helper'

describe 'nsd::pattern' do
  let(:title) do
    'test'
  end

  let(:params) do
    {
      :allow_notify => [
        ['1.2.3.4', 'test.'],
      ],
      :notifies     => [
        ['1.2.3.4', 'NOKEY'],
      ],
      :provide_xfr  => [
        ['1.2.3.4', 'BLOCKED'],
      ],
      :request_xfr  => [
        ['1.2.3.4', 'test.'],
      ],
    }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      context 'without nsd class included' do
        it { expect { should compile }.to raise_error(/must include the nsd base class/) }
      end

      context 'with nsd class included', :compile do
        let(:pre_condition) do
          'include ::nsd'
        end

        it { should contain_class('nsd') }
        it { should contain_concat__fragment('nsd pattern test').with_content(<<-EOS.gsub(/^ +/, ''))

          pattern:
          	name: "test"
          	allow-notify: 1.2.3.4 test.
          	notify: 1.2.3.4 NOKEY
          	provide-xfr: 1.2.3.4 BLOCKED
          	request-xfr: 1.2.3.4 test.
          EOS
        }
        it { should contain_nsd__pattern('test') }
      end
    end
  end
end
