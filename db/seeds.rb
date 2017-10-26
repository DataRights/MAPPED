# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
User.create!(email: 'mm.mani@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13') unless User.find_by email: 'mm.mani@gmail.com'
User.create!(email: 'shahriar.b@gmail.com', password_confirmation: 'eybaba13', password: 'eybaba13') unless User.find_by email: 'shahriar.b@gmail.com'

User.where(:confirmed_at => nil).each { |u| u.confirm }
