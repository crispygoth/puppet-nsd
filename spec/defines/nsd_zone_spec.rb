require 'spec_helper'

describe 'nsd::zone' do
  let(:title) do
    'example.com.'
  end

  let(:params) do
    {
      :content => 'invalid',
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
        it { should contain_concat__fragment('nsd zone example.com.').with_content(<<-EOS.gsub(/^ +/, ''))

          zone:
          	name: "example.com."
          	allow-notify: 1.2.3.4 test.
          	notify: 1.2.3.4 NOKEY
          	provide-xfr: 1.2.3.4 BLOCKED
          	request-xfr: 1.2.3.4 test.
          	zonefile: "master/example.com.zone"
          EOS
        }
        it { should contain_nsd__zone('example.com.') }

        case facts[:osfamily]
        when 'RedHat'
          it {
            should contain_file('/etc/nsd/master/example.com.zone').with(
              'owner' => 0,
              'group' => 0,
              'mode'  => '0644',
            )
          }
        when 'OpenBSD'
          it {
            should contain_file('/var/nsd/zones/master/example.com.zone').with(
              'owner' => 0,
              'group' => 0,
              'mode'  => '0644',
            )
          }
        end
      end
    end
  end
end
