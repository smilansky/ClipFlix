class Category < ActiveRecord::Base
  validates_presence_of :name
  has_many :videos, order: "created_at DESC"

  def recent_videos
    videos.limit(6)
  end
end