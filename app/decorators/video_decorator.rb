class VideoDecorator
  attr_reader :video

  def initialize(video)
    @video = video
  end



  def rating_show
    if @video.decorator.rating
      return "{@video.decorator.rating}/5.0"
    else
      return "N/A"
    end
  end

  def rating
    rating_total = 0
    @video.reviews.each do |review|
      rating_total += review.rating
    end

   return (rating_total == 0)? nil : rating_total/@video.reviews.count
  end
end