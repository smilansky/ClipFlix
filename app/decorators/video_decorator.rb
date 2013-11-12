class VideoDecorator
  attr_reader :video

  require 'Oembed'

  def initialize(video)
    @video = video
  end

  def rating_show
    if rating
      return "#{rating}/5.0"
    else
      return "N/A"
    end
  end

  def rating
    rating_total = 0
    @video.reviews.each do |review|
      rating_total += review.rating
    end
    
   return (rating_total == 0)? nil : @video.reviews.average(:rating).round
  end

  def vimeo_id
    correct_video_url = @video.video_url.starts_with?("http://") ? @video.video_url : "http://#{@video.video_url}"
    resource = OEmbed::Providers::Vimeo.get(correct_video_url)
    resource.video_id
  end
end