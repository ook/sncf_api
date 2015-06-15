require 'spec_helper'

describe SncfApi::Request do
  describe '.instance' do
    subject { SncfApi::Request.instance }
    context 'without params or ENV' do
      it { expect { subject }.to raise_error 'You MUST specify either api_token argument nor SNCF_API_TOKEN env variable' }
    end
  end
end
