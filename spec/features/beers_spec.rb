require 'spec_helper'

include OwnTestHelper

describe "Beer" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "beer can be added with valid name" do
    visit new_beer_path
    fill_in('beer[name]', with:'TestBeer')
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.from(0).to(1)

    expect(Brewery.first.beers.count).to eq(1)
  end

  it "invalid beer name results to redirection and nothing is added to system" do
    visit new_beer_path
    fill_in('beer[name]', with:"")
    select('Lager', from:'beer[style]')
    select('Koff', from:'beer[brewery_id]')

    expect{
      click_button "Create Beer"
    }.to change{Beer.count}.by(0)

    expect(current_path).to eq(beers_path)
    expect(page).to have_content "Name can't be blank"

  end
end