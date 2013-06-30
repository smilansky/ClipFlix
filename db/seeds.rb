# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Video.create(title: 'Family Guy', description: 'American adult animated sitcom.', small_cover_url: '/tmp/family_guy.jpg')
Video.create(title: 'Futurama', description: 'American animated science fiction sitcom.', small_cover_url: '/tmp/futurama.jpg')
Video.create(title: 'Monk', description: 'American comedy-drama detective mystery television series.', small_cover_url: '/tmp/monk.jpg', large_cover_url: '/tmp/monk_large.jpg')
Video.create(title: 'South Park', description: ' American adult animated sitcom.', small_cover_url: '/tmp/south_park.jpg')

