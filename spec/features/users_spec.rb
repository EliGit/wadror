require 'spec_helper'

include OwnTestHelper

describe "User" do
  before :each do
    FactoryGirl.create :user
  end

  describe "who has signed up" do
    it "can signin with right credentials" do
      sign_in(username:"Pekka", password:"Foobar1")


      expect(page).to have_content 'Welcome back!'
      expect(page).to have_content 'Pekka'
    end

    it "is redirected back to signin form if wrong credentials given" do
      sign_in(username:"Pekka", password:"wrong")

      expect(current_path).to eq(signin_path)
      expect(page).to have_content 'username and password do not match'
    end

    it "when signed up with good credentials, is added to the system" do
      visit signup_path
      fill_in('user_username', with:'Brian')
      fill_in('user_password', with:'Secret55')
      fill_in('user_password_confirmation', with:'Secret55')

      expect{
        click_button('Create User')
      }.to change{User.count}.by(1)
    end

    it "favorite style and brewery shown correctly" do
      brewery1 = FactoryGirl.create :brewery, name:"Koff"
      brewery2 = FactoryGirl.create :brewery, name:"Kaff"
      beer1 = FactoryGirl.create :beer, name:"iso 3", brewery:brewery1, style: "Lager"
      beer2 = FactoryGirl.create :beer, name:"Karhu", brewery:brewery2, style: "Weizen"

      FactoryGirl.create :rating, score: 10, user: User.first, beer: beer1
      FactoryGirl.create :rating, score: 15, user: User.first, beer: beer2

      visit user_path(User.first)
      expect(page).to have_content 'Favorite brewery: Kaff'
      expect(page).to have_content 'Favorite style: Weizen'
    end

  end
end