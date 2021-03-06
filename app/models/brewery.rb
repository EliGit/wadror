class Brewery < ActiveRecord::Base
  include AverageRating

  has_many :beers, dependent: :destroy
  has_many :ratings, through: :beers

  validates :name, presence: true
  validates :year, numericality: {greater_than_or_equal_to: 1042,
                                  less_than_or_equal_to: Proc.new {Time.new.year},
                                  only_integer: true}

  scope :active, -> { where active:true }
  scope :retired, -> { where active:[nil,false] }

  def print_report
    puts name
    puts "established at year #{year}"
    puts "number of beers #{beers.count}"
    puts "number of ratings #{ratings.count}"
  end

  def restart
    self.year = 2014
    puts "changed year to #{year}"
  end

  def self.top(n)
    Brewery.all.sort_by{ |b| -(b.average_rating||0) }.take(n)
  end
end
