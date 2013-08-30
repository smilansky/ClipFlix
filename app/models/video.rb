class Video < ActiveRecord::Base
  belongs_to :category
  has_many :reviews, order: "created_at DESC"
  has_many :queue_items
  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader

  validates_presence_of :title, :description

  def self.search_by_title(search_term)
    search_term.blank? ? [] : where("title LIKE ?", "%#{search_term}%").order("created_at DESC")
  end

  def decorator
    VideoDecorator.new(self)
  end
end