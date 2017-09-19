require 'spec_helper'

describe 'nsd' do

  let(:params) do
    {
      :ip_address => [
        '1.2.3.4',
        '5.6.7.8',
      ],
    }
  end

  context 'on unsupported distributions' do
    let(:facts) do
      {
        :osfamily => 'Unsupported'
      }
    end

    it { expect { should compile }.to raise_error(/not supported on an Unsupported/) }
  end

  on_supported_os.each do |os, facts|
    context "on #{os}", :compile do
      let(:facts) do
        facts
      end

      it { should contain_class('nsd') }
      it { should contain_class('nsd::config') }
      it { should contain_class('nsd::install') }
      it { should contain_class('nsd::params') }
      it { should contain_class('nsd::service') }
      it { should contain_concat__fragment('nsd server') }
      it { should contain_exec('nsd-control-setup') }
      it { should contain_service('nsd') }

      case facts[:osfamily]
      when 'RedHat'
        it {
          should contain_concat('/etc/nsd/nsd.conf').with(
            'owner' => 0,
            'group' => 'nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/etc/nsd').with(
            'owner' => 0,
            'group' => 0,
            'mode'  => '0644',
          )
        }
        it {
          should contain_file('/etc/nsd/master').with(
            'owner' => 0,
            'group' => 0,
            'mode'  => '0644',
          )
        }
        it {
          should contain_file('/etc/nsd/nsd_control.key').with(
            'owner' => 0,
            'group' => 'nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/etc/nsd/nsd_control.pem').with(
            'owner' => 0,
            'group' => 'nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/etc/nsd/nsd_server.key').with(
            'owner' => 0,
            'group' => 'nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/etc/nsd/nsd_server.pem').with(
            'owner' => 0,
            'group' => 'nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/etc/nsd/slave').with(
            'owner' => 0,
            'group' => 'nsd',
            'mode'  => '0664',
          )
        }
        it { should contain_file('/etc/sysconfig/nsd').with_ensure('absent') }
        it { should contain_package('nsd') }
      when 'OpenBSD'
        it {
          should contain_concat('/var/nsd/etc/nsd.conf').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/var/nsd/etc').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/var/nsd/etc/nsd_control.key').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/var/nsd/etc/nsd_control.pem').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/var/nsd/etc/nsd_server.key').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/var/nsd/etc/nsd_server.pem').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0640',
          )
        }
        it {
          should contain_file('/var/nsd/zones').with(
            'owner' => 0,
            'group' => 0,
            'mode'  => '0644',
          )
        }
        it {
          should contain_file('/var/nsd/zones/master').with(
            'owner' => 0,
            'group' => 0,
            'mode'  => '0644',
          )
        }
        it {
          should contain_file('/var/nsd/zones/slave').with(
            'owner' => 0,
            'group' => '_nsd',
            'mode'  => '0664',
          )
        }
        it { should have_package_resource_count(0) }
      end
    end
  end
end
