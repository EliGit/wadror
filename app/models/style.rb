class Style < ActiveRecord::Base
  include AverageRating

  has_many :beers
  has_many :ratings, through: :beers

  def to_s
    return "#{name}"
  end

  def self.top(n)
    Style.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end
