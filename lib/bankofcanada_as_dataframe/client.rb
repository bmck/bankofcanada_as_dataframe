require 'polars-df'
require 'httparty'
require 'date'

module BankofcanadaAsDataframe
  class Client
    # Get data for the given name from the Bank of Canada.

    include ::HTTParty
    base_uri "https://www.bankofcanada.ca/valet"
    format :json

    attr_reader :tag

    def initialize(series, options={})
      @tag = series
    end

    def fetch(start: nil, fin: nil)
      dta = observations({}).parsed_response['observations']
      dta = dta.select{|d| start.nil? ? true : Date.parse(d['d']) >= _parse_date(start) } unless start.nil?
      dta = dta.select{|d| fin.nil? ? true : Date.parse(d['d']) <= _parse_date(fin) } unless fin.nil?

      dates = dta.map{|d| Date.parse(d['d']) }
      vals = dta.map{|d| d[tag]['v'].to_f }

      Polars::DataFrame.new({Timestamps: dates, Values: vals})
    end

    def self.list_series
      dta = (get('/lists/series/json').parsed_response)['series']

      series = dta.keys
      desc = series.map{|s| [dta[s]['label'], dta[s]['description']].join('; ') }

      Polars::Config.set_tbl_rows(-1)
      Polars::DataFrame.new({Series: series, Description: desc})
    end

    protected

    def default_options
      { }
    end

    private

    def observations(options={})
      self.class.get("/observations/#{tag}/json", :query => options.merge(self.default_options))
    end

    def _parse_date(date_input)
      return date_input if date_input.is_a?(Date)
      Date.parse(date_input.to_s)
    end

  end
end
