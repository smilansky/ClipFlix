# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

def self.image_format(image)
  File.open(File.join(Rails.root, "/public/tmp/#{image}.jpg"))
end

dramas = Category.create(name: 'Drama')
sci_fi = Category.create(name: 'Science Fiction')
documentaries = Category.create(name: 'Documentary')
comedies = Category.create(name: 'Comedy')

# Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover: image_format('family_guy'), video_url: "vimeo.com/73355379", category: comedies)
# Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover: 'public/tmp/south_park.jpg', category: tvcomedies)
# Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover: 'public/tmp/futurama.jpg', category: tvcomedies)
# Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover: 'public/tmp/monk.jpg', large_cover: 'public/tmp/monk_large.jpg', category: tvdramas)
# Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover: 'public/tmp/family_guy.jpg', category: tvcomedies)
# Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover: 'public/tmp/south_park.jpg', category: tvcomedies)
# Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover: 'public/tmp/futurama.jpg', category: tvcomedies)
# Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover: 'public/tmp/monk.jpg', large_cover: 'public/tmp/monk_large.jpg', category: tvdramas)
# Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover: 'public/tmp/family_guy.jpg', category: tvcomedies)
# Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover: 'public/tmp/south_park.jpg', category: tvdramas)
# Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover: 'public/tmp/futurama.jpg', category: tvdramas)
# Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover: 'public/tmp/monk.jpg', large_cover: 'public/tmp/monk_large.jpg', category: tvdramas)
# Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover: 'public/tmp/futurama.jpg', category: tvdramas)
