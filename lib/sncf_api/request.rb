module SncfApi
  class Request
    IMPLEMENTATION = '20150615'
    BASE_URL = 'https://api.sncf.com/v1'

    class << self
      def instance(api_token: ENV['SNCF_API_TOKEN'], plan: {name: 'Free', limits: { per_day: 3_000, per_month: 90_000 }})
        raise ArgumentError, "You MUST specify either api_token argument nor SNCF_API_TOKEN env variable" unless api_token
        @instances ||= {}
        @instances[api_token] ||= new
      end
    end

  private
    def initialize
    end
  end
end
