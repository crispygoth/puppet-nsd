require 'spec_helper'

describe 'nsd::zone' do
  let(:title) do
    'test'
  end

  let(:params) do
    {
      :content => 'invalid',
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
        it { should contain_concat__fragment('nsd zone test') }
        it { should contain_nsd__zone('test') }

        case facts[:osfamily]
        when 'RedHat'
          it {
            should contain_file('/etc/nsd/master/test.zone').with(
              'owner' => 0,
              'group' => 0,
              'mode'  => '0644',
            )
          }
        when 'OpenBSD'
          it {
            should contain_file('/var/nsd/zones/master/test.zone').with(
              'owner' => 0,
              'group' => 0,
              'mode'  => '0644',
            )
          }
        end

        context 'and a TSIG key' do
          let(:params) do
            super().merge(
              {
                :notifies    => [
                  '1.2.3.4 test',
                ],
                :provide_xfr => [
                  '1.2.3.4 test',
                ],
              }
            )
          end

          context 'with no key defined' do
            it { expect { should compile }.to raise_error(/Could not find resource/) }
          end

          context 'with a key defined', :compile do
            let(:pre_condition) do
              super() + ' ::nsd::key { "test": algorithm => "hmac-sha1", secret => "" }'
            end

            it { should contain_concat__fragment('nsd zone test').that_requires('Nsd::Key[test]') }
            it { should contain_concat__fragment('nsd key test') }
            it { should contain_nsd__key('test') }
          end
        end

        context 'and a pattern' do
          let(:params) do
            super().merge(
              {
                :include_pattern => 'test'
              }
            )
          end

          context 'with no pattern defined' do
            it { expect { should compile }.to raise_error(/Could not find resource/) }
          end

          context 'with a pattern defined', :compile do
            let(:pre_condition) do
              super() + ' ::nsd::pattern { "test": }'
            end

            it { should contain_concat__fragment('nsd zone test').that_requires('Nsd::Pattern[test]') }
            it { should contain_concat__fragment('nsd pattern test') }
            it { should contain_nsd__pattern('test') }
          end
        end
      end
    end
  end
end
