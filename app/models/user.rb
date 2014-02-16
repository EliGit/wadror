class User < ActiveRecord::Base
  include AverageRating

  validates :username, uniqueness: true,
            length: { in: 3..15 }

  validates :password, length: { minimum: 3 },
            format: { with: /.*(\d.*[A-Z]|[A-Z].*\d).*/,
                      message: "should contain a uppercase letter and a number" }


  has_secure_password

  has_many :ratings, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :memberships, dependent: :destroy
  has_many :beer_clubs, through: :memberships


  def favorite_beer
    return nil if ratings.empty?
    ratings.order(score: :desc).limit(1).first.beer
  end

  def favorite_style
    return nil if ratings.empty?
    ##gets correct style id, improve later
    Style.find(ratings.joins(:beer).group("style_id").average("score").max_by{|k,v| v}[0])
  end

  def favorite_brewery
    return nil if ratings.empty?
    Brewery.find(ratings.joins(:beer).group("brewery_id").average("score").max_by{|k,v| v}[0])
  end
end