# frozen_string_literal: true

require 'set'
require 'bundler/setup'
require_relative '../lib/bankofcanada_as_dataframe'

failures = []
failures << 'version' if BankofcanadaAsDataframe::VERSION.to_s.empty?
client = BankofcanadaAsDataframe::Client.new('FXUSDCAD')
failures << 'instantiate' unless client.is_a?(BankofcanadaAsDataframe::Client)
failures << 'tag' unless client.tag == 'FXUSDCAD'
failures << 'fetch' unless client.respond_to?(:fetch)
failures << 'list_series' unless BankofcanadaAsDataframe::Client.respond_to?(:list_series)

if failures.empty?
  puts 'test_client: ok'
else
  abort "test_client failed: #{failures.join(', ')}"
end
