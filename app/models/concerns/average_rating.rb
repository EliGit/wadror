module AverageRating
  extend ActiveSupport::Concern
  def average_rating
    ratings.average :score
    #ratings.inject(0.to_f){|result, element| result+element.score}/ratings.count

  end
end
