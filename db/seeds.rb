# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.create(name: "Test Organization", active: true)
User.create(username: "minkyung", first_name: "Minkyung", last_name: "Lee", email: "test@test.com", phone: "111111111", password: "secret", password_confirmation: "secret", role: "admin", organization_id: 1, active: true)