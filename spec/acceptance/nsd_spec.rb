require 'spec_helper_acceptance'

describe 'nsd' do

  case fact('osfamily')
  when 'RedHat'
    conf_dir   = '/etc/nsd'
    group      = 'nsd'
    root_group = 'root'
    zonesdir   = '/etc/nsd'
  when 'OpenBSD'
    conf_dir   = '/var/nsd/etc'
    group      = '_nsd'
    root_group = 'wheel'
    zonesdir   = '/var/nsd/zones'
  end

  it 'should work with no errors' do

    pp = <<-EOS
      include ::nsd

      ::nsd::key { 'localhost.':
        algorithm => 'hmac-sha256',
        secret    => 'NwUfn0VTJr/tQABDTocrc2D6Ddto9JYQjD0KUkRc7HI=',
      }

      ::nsd::zone { 'example.com.':
        source      => '/root/example.com.zone',
        provide_xfr => [
          ['127.0.0.0/8', 'localhost.'],
          ['::1', 'localhost.'],
        ],
      }

      if $::osfamily == 'RedHat' {

        package { 'bind-utils':
          ensure => present,
        }

        include ::epel
        Class['::epel'] -> Class['::nsd']
      }
    EOS

    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes  => true)
  end

  describe package('nsd'), :if => fact('osfamily') != 'OpenBSD' do
    it { should be_installed }
  end

  describe file('/etc/sysconfig/nsd'), :if => fact('osfamily') == 'RedHat' do
    it { should_not exist }
  end

  describe file(zonesdir) do
    it { should be_directory }
    it { should be_mode 755 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
  end

  describe file(conf_dir), :if => fact('osfamily') == 'OpenBSD' do
    it { should be_directory }
    it { should be_mode 750 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  describe file("#{conf_dir}/nsd.conf") do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into group }
  end

  %w(nsd_control.key nsd_control.pem nsd_server.key nsd_server.pem).each do |f|
    describe file("#{conf_dir}/#{f}") do
      it { should be_file }
      it { should be_mode 640 }
      it { should be_owned_by 'root' }
      it { should be_grouped_into group }
    end
  end

  describe file("#{zonesdir}/master/example.com.zone") do
    it { should be_file }
    it { should be_mode 644 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into root_group }
  end

  describe service('nsd') do
    it { should be_enabled }
    it { should be_running }
  end

  describe command('nsd-control status') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /version:\s+\d+\.\d+\.\d+/ }
    its(:stdout) { should match /verbosity:\s+0/}
    its(:stdout) { should match /ratelimit:\s+200/}
  end

  describe command('dig @localhost version.server txt chaos +time=1 +tries=1') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /version\.server\.\s+0\s+CH\s+TXT\s+"NSD\s+\d+\.\d+\.\d+"/ }
  end

  describe command('dig @localhost example.com axfr +time=1 +tries=1') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /; Transfer failed\./ }
  end

  describe command('dig -y hmac-sha256:localhost.:NwUfn0VTJr/tQABDTocrc2D6Ddto9JYQjD0KUkRc7HI= @localhost example.com axfr +time=1 +tries=1') do
    its(:exit_status) { should eq 0 }
    its(:stdout) { should match /example\.com\.\s+86400\s+IN\s+SOA\s+ns1\.example\.com\.\s+hostmaster\.example\.com\.\s+\d+\s+\d+\s+\d+\s+\d+\s+\d+/ }
    its(:stdout) { should match /localhost\.\s+0\s+ANY\s+TSIG\s+hmac-sha256\.\s+\d+\s+\d+\s+\d+\s+\S+\s+\d+\s+NOERROR\s+0/ }
    its(:stdout) { should_not match /; Transfer failed\./ }
  end
end
