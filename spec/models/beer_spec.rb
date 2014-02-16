require 'spec_helper'

describe Beer do
  let(:style){ FactoryGirl.create(:style) }

  it "created and saved if has name and style" do
    beer = Beer.create name: "TestBeer", style: style

    expect(beer).to be_valid
    expect(Beer.count).to eq(1)
  end

  it "not saved without name" do
    beer = Beer.create style: style

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end

  it "not saved without a style" do
    beer = Beer.create name: "TestBeer"

    expect(beer).not_to be_valid
    expect(Beer.count).to eq(0)
  end
end
