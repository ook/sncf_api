require 'spec_helper'

describe SncfApi::Request do
  describe '.instance' do
    context 'with empty or without params or ENV' do
      it { expect { SncfApi::Request.instance }.to raise_error 'You MUST specify either api_token argument nor SNCF_API_TOKEN env variable' }
      it { expect { SncfApi::Request.instance(api_token: nil) }.to raise_error 'You MUST specify either api_token argument nor SNCF_API_TOKEN env variable' }
      it { expect { SncfApi::Request.instance(api_token: '') }.to raise_error 'You MUST specify either api_token argument nor SNCF_API_TOKEN env variable' }
    end

    context 'with ENV or api_token param' do
      it { expect(SncfApi::Request.instance(api_token: 'token')).to be_a(SncfApi::Request) }
      it 'should return different instance according to token' do
        instance1 = SncfApi::Request.instance(api_token: 'token1')
        expect(SncfApi::Request.instance(api_token: 'token1')).to be(instance1)
        expect(SncfApi::Request.instance(api_token: 'token2')).not_to be(instance1)
        expect(SncfApi::Request.instance(api_token: 'token2')).to be_a(SncfApi::Request)
      end
    end
  end
end
