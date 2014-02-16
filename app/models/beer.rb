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

end
