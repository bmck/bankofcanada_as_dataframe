require 'spec_helper'
require 'json'

RSpec.describe BankofcanadaAsDataframe::Client do
  let(:series_code) { 'IEXE0102' }
  let(:observations_fixture) do
    JSON.parse(File.read(File.join(__dir__, '..', 'fixtures', 'observations_IEXE0102.json')))
  end
  let(:list_series_fixture) do
    JSON.parse(File.read(File.join(__dir__, '..', 'fixtures', 'list_series.json')))
  end

  describe '#initialize' do
    it 'sets the tag attribute' do
      client = described_class.new(series_code)
      expect(client.tag).to eq(series_code)
    end

    it 'accepts options parameter' do
      expect { described_class.new(series_code, foo: 'bar') }.not_to raise_error
    end
  end

  describe '#fetch' do
    let(:client) { described_class.new(series_code) }

    before do
      stub_request(:get, "https://www.bankofcanada.ca/valet/observations/#{series_code}/json")
        .to_return(status: 200, body: observations_fixture.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Polars::DataFrame' do
      result = client.fetch
      expect(result).to be_a(Polars::DataFrame)
    end

    it 'returns a dataframe with Timestamps and Values columns' do
      result = client.fetch
      expect(result.columns).to eq(['Timestamps', 'Values'])
    end

    it 'returns all observations when no date filters are provided' do
      result = client.fetch
      expect(result.height).to eq(7)
    end

    it 'converts dates correctly' do
      result = client.fetch
      first_date = result['Timestamps'][0]
      expect(first_date).to eq(Date.parse('2020-01-02'))
    end

    it 'converts values correctly' do
      result = client.fetch
      first_value = result['Values'][0]
      expect(first_value).to be_within(0.0001).of(1.2985)
    end

    context 'with start date filter' do
      it 'filters observations on or after the start date' do
        result = client.fetch(start: '2020-01-07')
        expect(result.height).to eq(4)
        first_date = result['Timestamps'][0]
        expect(first_date).to eq(Date.parse('2020-01-07'))
      end
    end

    context 'with end date filter' do
      it 'filters observations on or before the end date' do
        result = client.fetch(fin: '2020-01-07')
        expect(result.height).to eq(4)
        last_date = result['Timestamps'][-1]
        expect(last_date).to eq(Date.parse('2020-01-07'))
      end
    end

    context 'with both start and end date filters' do
      it 'filters observations within the date range' do
        result = client.fetch(start: '2020-01-03', fin: '2020-01-08')
        expect(result.height).to eq(4)
        first_date = result['Timestamps'][0]
        last_date = result['Timestamps'][-1]
        expect(first_date).to eq(Date.parse('2020-01-03'))
        expect(last_date).to eq(Date.parse('2020-01-08'))
      end
    end
  end

  describe '.list_series' do
    before do
      stub_request(:get, "https://www.bankofcanada.ca/valet/lists/series/json")
        .to_return(status: 200, body: list_series_fixture.to_json, headers: { 'Content-Type' => 'application/json' })
    end

    it 'returns a Polars::DataFrame' do
      result = described_class.list_series
      expect(result).to be_a(Polars::DataFrame)
    end

    it 'returns a dataframe with Series and Description columns' do
      result = described_class.list_series
      expect(result.columns).to eq(['Series', 'Description'])
    end

    it 'returns all available series' do
      result = described_class.list_series
      expect(result.height).to eq(5)
    end

    it 'includes series codes' do
      result = described_class.list_series
      series_codes = result['Series'].to_a
      expect(series_codes).to include('IEXE0102', 'FXCADUSD', 'FXUSDCAD', 'V122491', 'STATIC_INDINF')
    end

    it 'combines label and description with semicolon separator' do
      result = described_class.list_series
      descriptions = result['Description'].to_a
      expect(descriptions[0]).to match(/;/)
      expect(descriptions[0]).to include('US dollar, noon spot rate')
      expect(descriptions[0]).to include('United States dollar at noon New York, daily spot rate')
    end
  end
end
