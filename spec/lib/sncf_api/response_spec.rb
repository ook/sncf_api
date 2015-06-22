require 'spec_helper'

describe SncfApi::Response do
  describe '#content' do
    let(:response) { SncfApi::Response.new(path: '/fake-path', request: SncfApi::Request.instance(api_token: 'fake-token')) }

    [400,401,404, 500].each do |code|
      it "should raise error when HTTP status != 200 (#{code})" do
        allow(Http).to receive_message_chain(:basic_auth, :get).and_return(Http::Response.new code, nil, nil,nil)
        expect { response }.to raise_error ArgumentError, /^Unauthorized \(#{code}\)/
      end
    end

    it "should LET IT GO, LET IT GO, when status is 200" do
      fixture_pathname = Pathname(__FILE__) + '..' + '..' + '..' + 'fixtures' + 'coverage_page1.json'
      expected = Oj.load(fixture_pathname.read)
      reader, writer  = IO.pipe
      writer << fixture_pathname.read << "\n"
      writer.close
      allow(Http).to receive_message_chain(:basic_auth, :get).and_return(Http::Response.new 200, nil, {'Content-Type' => 'application/json'}, reader)
      expect(SncfApi::Response.new(path: '/coverage', request: SncfApi::Request.instance(api_token: 'fake-token')).content).to eq(expected)
    end
  end

  describe '#links which expose HATEOAS links. The keys are the rel' do
    it 'expose rel as keys and links as values' do
      fixture_pathname = Pathname(__FILE__) + '..' + '..' + '..' + 'fixtures' + 'coverage_page1.json'
      expected = Oj.load(fixture_pathname.read)['links']
      reader, writer  = IO.pipe
      writer << fixture_pathname.read << "\n"
      writer.close
      allow(Http).to receive_message_chain(:basic_auth, :get).and_return(Http::Response.new 200, nil, {'Content-Type' => 'application/json'}, reader)
      expect(SncfApi::Response.new(path: '/coverage', request: SncfApi::Request.instance(api_token: 'fake-token')).links).to eq(expected)
    end
  end
end
