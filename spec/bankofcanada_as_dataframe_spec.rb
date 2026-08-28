require "spec_helper"

RSpec.describe BankofcanadaAsDataframe do
  it "has a version number" do
    expect(BankofcanadaAsDataframe::VERSION).not_to be nil
  end

  it "loads the Client class" do
    expect(defined?(BankofcanadaAsDataframe::Client)).to eq("constant")
  end
end
