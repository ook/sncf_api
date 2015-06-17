module SncfApi
  class Request
    IMPLEMENTATION = '20150615'
    BASE_URL = 'https://api.sncf.com/v1'

    class << self
      def instance(api_token: ENV['SNCF_API_TOKEN'], plan: {name: 'Free', limits: { per_day: 3_000, per_month: 90_000 }})
        api_token = nil if !api_token.is_a?(String) || api_token.strip == ''
        raise ArgumentError, "You MUST specify either api_token argument nor SNCF_API_TOKEN env variable" unless api_token
        @instances ||= {}
        @instances[api_token] ||= new(plan: plan[:limits])
      end

      def drop_instance(api_token: ENV['SNCF_API_TOKEN'])
        @instances.delete(api_token)
        @instances.count
      end
    end

    # My understanding of SNCF quota is that the countdown start at the very first call of a dau and the plan start on that instant
    def countdown
      @countdown ||= default_countdown  
    end

  private
    def initialize(plan:)
      @plan = plan
    end

    def default_countdown
      { per_day: @plan[:per_day], per_month: @plan[:per_month], started_at: now }
    end

    def now
      Time.now.utc
    end

    QUOTA_PERIODS = { 
                      per_day:        24 * 60 * 60,
                      per_month: 30 * 24 * 60 * 60
                     }
    def decrease_quotas
      @countdown ||= default_countdown
      right_now = now
      QUOTA_PERIODS.each do |key, period|
        if @countdown[:started_at] <= (right_now - period)
          @countdown[key] = @plan[key]
          @countdown[:started_at] = right_now
        end
      end
      QUOTA_PERIODS.keys.each { |k| @countdown[k] -= 1 }
      @countdown
    end
  end
end
