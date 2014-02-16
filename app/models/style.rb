class Style < ActiveRecord::Base
  has_many :beers

  def to_s
    return "#{name}"
  end
end
