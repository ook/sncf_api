$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'sncf_api'
require 'pry'
require 'pry-byebug'

require "codeclimate-test-reporter"
CodeClimate::TestReporter.start
