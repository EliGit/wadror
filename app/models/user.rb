class User < ActiveRecord::Base
  include AverageRating

  has_many :ratings, dependent: :destroy
  has_many :memberships, dependent: :destroy
  has_many :beers, through: :ratings
  has_many :beer_clubs, through: :memberships

  has_secure_password

  validates :username, uniqueness: true, length: { minimum: 3, maximum: 15 }
  validates :password, length: { minimum: 4}, format: {with: /(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z])/}


#  (?=.*[a-z])        // at least one lower case letter
#  (?=.*[A-Z])        // at least one upper case letter
#  (?=.*\d)           // if at least one digit
#  (?=.*[_\W])        // at least one underscore or non-word character exists

end
