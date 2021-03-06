class Beer < ActiveRecord::Base
  include AverageRating

  belongs_to :brewery
  belongs_to :style
  has_many :ratings, dependent: :destroy
  has_many :raters, through: :ratings, source: :user

  validates :name, :style, presence: true



  def to_s
    return "#{name} by #{brewery.name}"
  end

  def self.top(n)
    Beer.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end

end
