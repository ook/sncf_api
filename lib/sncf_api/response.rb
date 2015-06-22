require 'http'
require 'oj'
module SncfApi
  # A reponse represent a request response from API. Note that means only ONE PAGE AT A TIME
  # There's helper methods like #each_page and #page(index) to help you to crawl easily in the 
  # result
  class Response
    BASE_URL = 'https://api.sncf.com/v1'

    attr_reader :response, :request, :body, :content, :http_params
    attr_reader :pagination, :start_page

    KNOWN_HTTP_ERROR_CODES = [400, 401, 404, 500]
    def initialize(path:, request:, http_params: nil)
      @path = path
      @http_params = http_params
      @response = Http.basic_auth(:user => request.api_token, :pass => nil).get(BASE_URL + @path, params: @http_params)
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
        if @response.content_type.mime_type == 'application/json'
          @content = Oj.load(@content) 
          @pagination = @content['pagination']
          @start_page = @pagination ? @pagination['start_page'] : 0
        end
      end
      if KNOWN_HTTP_ERROR_CODES.include?(@response.code)
        raise ArgumentError, "Unauthorized (#{@response.code}) #{@response.body}"
      end
    end

    # return Hash
    def links
      @content['links']
    end

    def page(index=0)
      new_http_params = @http_params.dup
      new_http_params['start_page'] = index
      SncfApi::Response.new(path: @path, request: @request, http_params: new_http_params)
    end

    # Execute given block from the current page until last rel=next
    def each_page(&block)
      yield @content
      content = @content
      loop do
        next_page = content && content['links'] && content['links'].find { |e| e['type'] == 'next' }
        break unless next_page
        resp = Http.basic_auth(user: request.api_token, pass: nil).get(next_page['href'])
        @request.send :decrease_quotas
        break unless resp.code == 200 
        break unless resp.content_type.mime_type == 'application/json'
        content = ''
        loop do
          chunk = resp.body.readpartial(HTTP::Connection::BUFFER_SIZE) rescue nil
          break if chunk.nil?
          content << chunk
        end
        content = Oj.load(content)
        yield content
      end
    end

  end
end
