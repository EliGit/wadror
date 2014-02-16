require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end

  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if password too short" do
    user = User.create username:"Pekka", password:"S1", password_confirmation:"S1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end

  it "is not saved if psswd only letters" do
    user = User.create username:"Pekka", password:"S1", password_confirmation:"S1"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
end

describe "with a proper password" do
  let(:user){ FactoryGirl.create(:user) }

  it "is saved" do
    expect(user).to be_valid
    expect(User.count).to eq(1)
  end

  it "and with two ratings, has the correct average rating" do
    user.ratings << FactoryGirl.create(:rating)
    user.ratings << FactoryGirl.create(:rating2)

    expect(user.ratings.count).to eq(2)
    expect(user.average_rating).to eq(15.0)
  end
end

describe "favorite beer" do
  let(:user){FactoryGirl.create(:user) }

  it "has method for determining one" do
    user.should respond_to :favorite_beer
  end

  it "without ratings does not have one" do
    expect(user.favorite_beer).to eq(nil)
  end

  it "is the only rated if only one rating" do
    beer = create_beer_with_rating(10, user)

    expect(user.favorite_beer).to eq(beer)
  end

  it "is the one with highest rating if several rated" do
    create_beers_with_ratings(10, 20, 15, 7, 9, user)
    best = create_beer_with_rating(25, user)

    expect(user.favorite_beer).to eq(best)
  end
end

describe "favorite style" do
  let(:user){FactoryGirl.create(:user) }

  it "has method for determining one" do
    user.should respond_to :favorite_style
  end

  it "without ratings does not have one" do
    expect(user.favorite_style).to eq(nil)
  end

  it "is the only rated if only one rating" do
    beer = create_beer_with_rating(10, user)

    expect(user.favorite_style).to eq(user.ratings.first.beer.style)
  end

  it "is the one with highest rating if several rated" do
    best = FactoryGirl.create(:style)
    create_beers_with_ratings_and_style(10, 20, 15, 7, 9, user, FactoryGirl.create(:style, name: "Lager"))
    create_beers_with_ratings_and_style(10, 20, 15, 7, 10, user, best)

    expect(user.favorite_style).to eq(best)
  end
end

describe "favorite brewery" do
  let(:user){FactoryGirl.create(:user) }

  it "has method for determining one" do
    user.should respond_to :favorite_brewery
  end

  it "without ratings does not have one" do
    expect(user.favorite_brewery).to eq(nil)
  end

  it "is the only with ratings if only one rating" do
    beer = create_beer_with_rating(10, user)

    expect(user.favorite_brewery).to eq(user.ratings.first.beer.brewery)
  end

  it "is the one with highest average rating if several rated" do
    create_beers_with_ratings_and_style(10, 20, 15, 7, 9, user, FactoryGirl.create(:style, name: "Lager"))
    create_beers_with_ratings_and_style(10, 20, 15, 7, 10, user, FactoryGirl.create(:style))

    best = FactoryGirl.create(:brewery, name: "bestTest")
    FactoryGirl.create(:beer, brewery: best)
    FactoryGirl.create(:rating, score: 50, beer: best.beers.first, user: user)

    expect(user.favorite_brewery).to eq(best)
  end

end

# Helpers
def create_beers_with_ratings_and_style(*scores, user, style)
  scores.each do |score|
    create_beer_with_rating_and_style score, user, style
  end
end

def create_beer_with_rating_and_style(score,  user, style)
  beer = FactoryGirl.create(:beer, style: style)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end



def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating score, user
  end
end

def create_beer_with_rating(score,  user)
  beer = FactoryGirl.create(:beer)
  FactoryGirl.create(:rating, score:score,  beer:beer, user:user)
  beer
end
