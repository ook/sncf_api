require 'http'
require 'oj'
module SncfApi
  class Response
    BASE_URL = 'https://api.sncf.com/v1'

    attr_reader :response, :request, :body, :content

    KNOWN_HTTP_ERROR_CODES = [400, 401, 404, 500]
    def initialize(path:, request:)
      @response = Http.basic_auth(:user => request.api_token, :pass => nil).get(BASE_URL + path)
      @body = response.body
      @request = request
      @request.send :decrease_quotas

      if @response.code == 200
        @content = ''
        loop do
          chunk = @body.readpartial(HTTP::Connection::BUFFER_SIZE) rescue nil
          break if chunk.nil?
          @content << chunk
        end
        @content = Oj.load(@content) if @response.content_type.mime_type == 'application/json'
      end
      if KNOWN_HTTP_ERROR_CODES.include?(@response.code)
        raise ArgumentError, "Unauthorized (#{@response.code}) #{@response.body}"
      end
    end

  end
end
