require 'spec_helper'
include OwnTestHelper

describe "Rating" do
  let!(:brewery) { FactoryGirl.create :brewery, name:"Koff" }
  let!(:beer1) { FactoryGirl.create :beer, name:"iso 3", brewery:brewery }
  let!(:beer2) { FactoryGirl.create :beer, name:"Karhu", brewery:brewery }
  let!(:user) { FactoryGirl.create :user }

  before :each do
    sign_in(username:"Pekka", password:"Foobar1")
  end

  it "when given, is registered to the beer and user who is signed in" do
    visit new_rating_path
    select('iso 3', from:'rating[beer_id]')
    fill_in('rating[score]', with:'15')

    expect{
      click_button "Create Rating"
    }.to change{Rating.count}.from(0).to(1)

    expect(user.ratings.count).to eq(1)
    expect(beer1.ratings.count).to eq(1)
    expect(beer1.average_rating).to eq(15.0)
  end

  it "added ratings and total number shown on ratings page" do
    FactoryGirl.create :rating, user: user, score: 10, beer: beer1

    visit ratings_path
    expect(page).to have_content 'iso 3 10 Pekka'
    expect(page).to have_content 'Number of ratings: 1'
  end

  it "shown on user page" do
    FactoryGirl.create :rating, user: user, score: 10, beer: beer1
    FactoryGirl.create :rating, score: 10, beer: beer1

    visit user_path(user)
    expect(page).to have_content 'iso 3 10 delete'
    expect(page).to have_content 'Has made 1 rating'
  end

  it "removed from db when removed by user" do
    FactoryGirl.create :rating, user: user, score: 10, beer: beer1

    expect(Rating.all.count).to eq(1)
    visit user_path(user)

    click_link "delete"
    expect(Rating.all.count).to eq(0)
  end

end