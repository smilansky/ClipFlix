# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

tvcomedies = Category.create(name: 'TV Comedies')
tvdramas = Category.create(name: 'TV Dramas')
realitytv = Category.create(name: 'Reality TV')

Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover_url: '/tmp/family_guy.jpg', category: tvcomedies)
southp = Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover_url: '/tmp/south_park.jpg', category: tvcomedies)
Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover_url: '/tmp/futurama.jpg', category: tvcomedies)
Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: tvdramas)
Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover_url: '/tmp/family_guy.jpg', category: tvcomedies)
Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover_url: '/tmp/south_park.jpg', category: tvcomedies)
Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover_url: '/tmp/futurama.jpg', category: tvcomedies)
Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: tvdramas)
Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover_url: '/tmp/family_guy.jpg', category: tvcomedies)
Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover_url: '/tmp/south_park.jpg', category: tvdramas)
Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover_url: '/tmp/futurama.jpg', category: tvdramas)
Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg', category: tvdramas)
Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover_url: '/tmp/futurama.jpg', category: tvdramas)

daniel = User.create(fullname: 'Daniel', email: 'dsmilansky@gmail.com', password: 'bigdeal23')
rachel = User.create(fullname: 'Rachel', email: 'rmcooper11@email.mmc.edu', password: 'rachel')

Review.create(user: daniel, video: southp, rating: 4, content: 'Amazing!')
Review.create(user: daniel, video: southp, rating: 3, content: 'Amazing!')