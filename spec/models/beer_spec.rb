require 'spec_helper'

describe Beer do
  it "created and saved if has name and style" do
    beer = Beer.create name: "TestBeer", style: "Weizen"

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "not saved without name" do
    beer = Beer.create style: "Weizen"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "not saved without a style" do
    beer = Beer.create name: "TestBeer"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
