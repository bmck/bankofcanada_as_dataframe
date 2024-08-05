# EconDataReader

Up to date remote economic data access for ruby, using Polars dataframes. 

This package will fetch economic and financial information from the Bank of Canada's API, and return the results as a Polars dataframe.  For details regarding the data available from the Bank of Canada, see https://www.bankofcanada.ca/valet/docs .


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'bankofcanada_as_dataframe'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install bankofcanada_as_dataframe


## Usage

``` ruby
3.1.2 :001 > BankofcanadaAsDataframe::Client.new('IEXE0102').fetch
 => 
shape: (2_504, 2)                                                                  
┌────────────┬────────┐                                                            
│ Timestamps ┆ Values │                                                            
│ ---        ┆ ---    │                                                            
│ date       ┆ f64    │                                                            
╞════════════╪════════╡                                                            
│ 2007-05-01 ┆ 1.1105 │                                                            
│ 2007-05-02 ┆ 1.1087 │                                                            
│ 2007-05-03 ┆ 1.1066 │                                                            
│ 2007-05-04 ┆ 1.1075 │                                                            
│ 2007-05-07 ┆ 1.1018 │                                                            
│ …          ┆ …      │                                                            
│ 2017-04-24 ┆ 1.3511 │
│ 2017-04-25 ┆ 1.3565 │
│ 2017-04-26 ┆ 1.3612 │
│ 2017-04-27 ┆ 1.3624 │
│ 2017-04-28 ┆ 1.365  │
└────────────┴────────┘ 
3.1.2 :002 > BankofcanadaAsDataframe::Client.new('IEXE0102').fetch(start: '2010-01-01', fin: '2016-01-01')
 => 
shape: (1_502, 2)                                                                              
┌────────────┬────────┐                                                                        
│ Timestamps ┆ Values │                                                                        
│ ---        ┆ ---    │                                                                        
│ date       ┆ f64    │                                                                        
╞════════════╪════════╡                                                                        
│ 2010-01-04 ┆ 1.0414 │                                                                        
│ 2010-01-05 ┆ 1.039  │                                                                       
│ 2010-01-06 ┆ 1.0325 │                                                                       
│ 2010-01-07 ┆ 1.035  │                                                                       
│ 2010-01-08 ┆ 1.0309 │                                                                       
│ …          ┆ …      │                                                                       
│ 2015-12-23 ┆ 1.3857 │                                                                       
│ 2015-12-24 ┆ 1.3845 │                                                                       
│ 2015-12-29 ┆ 1.3823 │
│ 2015-12-30 ┆ 1.3885 │
│ 2015-12-31 ┆ 1.384  │
└────────────┴────────┘ 
```

## Documentation

TBD

## Contributing

Others are welcome to contribute to the project.

The following conventions are intended for this project.
 * Different sources are intended to reside in different classes.  
 * API keys (if needed) should be able to be set in the single configuration file.  
 * Series should be able to be identified via a single unique string, provided in the constructor.
 * When fetched, the dataset may be filtered based on optional (hash) arguments.
 * Output should be provided in a consistent DataFrame format (currently Polars::DataFrame).

Bug reports and pull requests are welcome on GitHub at https://github.com/bmck/econ_data_reader.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
