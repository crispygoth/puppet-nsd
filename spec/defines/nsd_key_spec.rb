require 'spec_helper'

describe 'nsd::key' do
  let(:title) do
    'test.'
  end

  let(:params) do
    {
      :algorithm => 'hmac-sha256',
      :secret    => 'K2tf3TRjvQkVCmJF3/Z9vA==',
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
        it { should contain_concat__fragment('nsd key test.') }
        it { should contain_nsd__key('test.') }
      end
    end
  end
end
