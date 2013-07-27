class QueueItem < ActiveRecord::Base
  belongs_to :user
  belongs_to :video

  delegate :category, to: :video
  delegate :title, to: :video, prefix: :video

  validates_numericality_of :position, :only_integer => true

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review == nil ? nil : review.rating
  end

  def rating=(new_rating)
    review = Review.where(user_id: user.id, video_id: video.id).first
    if review == nil
      review = Review.new(user_id: user.id, video_id: video.id, rating: new_rating)
      review.save(validate: false)
    else  
      review.update_column(:rating, new_rating)
    end
  end

  def category_name
    category.name
  end

end


