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

  describe '#countdown' do
    context 'with a free account' do

      let!(:frozen_now) { Time.new(2009,5,16, 14).utc }
      let!(:default_countdown) { { per_day: 3_000, per_month: 90_000, started_at: frozen_now } }

      before(:each) do
        allow_any_instance_of(Time).to receive_message_chain(:now, :utc).and_return(frozen_now)
        allow_any_instance_of(SncfApi::Request).to receive(:now).and_return(frozen_now)
        @request = SncfApi::Request.instance(api_token: 'fakeToken')
      end

      after(:each) do
        SncfApi::Request.drop_instance(api_token: 'fakeToken')
      end

      it 'should have a stock of 3 000 calls per day and 90K per month' do
        expect(@request.countdown).to eq(default_countdown)
      end

      it 'should decrease countdown after each successful callahave a stock of 3 000 calls per day and 90K per month' do
        cd_after_a_request = default_countdown.dup
        cd_after_a_request[:per_day] -= 1
        cd_after_a_request[:per_month] -= 1
        @request.send(:decrease_quotas)
        expect(@request.countdown).to eq(cd_after_a_request)
      end

      it 'should reset day countdown after exceed the period time without touching month countdown' do
        before_request_count = 1_000
        before_request_count.times { @request.send(:decrease_quotas) }
        cd_after_a_request = default_countdown.dup
        cd_after_a_request[:per_day] -= before_request_count
        cd_after_a_request[:per_month] -= before_request_count
        expect(@request.countdown).to eq(cd_after_a_request)

        the_day_after = frozen_now + SncfApi::Request::QUOTA_PERIODS[:per_day]
        allow_any_instance_of(Time).to receive_message_chain(:now, :utc).and_return(the_day_after)
        allow_any_instance_of(SncfApi::Request).to receive(:now).and_return(the_day_after)

        cd_after_a_request[:per_day] = default_countdown[:per_day] - 1
        cd_after_a_request[:per_month] -= 1
        cd_after_a_request[:started_at] = the_day_after
        @request.send(:decrease_quotas)
        expect(@request.countdown).to eq(cd_after_a_request)
      end
    end
  end
end
