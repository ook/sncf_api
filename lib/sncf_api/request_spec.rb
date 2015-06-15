require 'spec_helper'

describe SncfApi::Request do
  describe '.instance' do
    context 'without params or ENV' do
      expect(SncfApi::Request).to raise_error ArgumentError, 'Meuh'
    end
  end
end
