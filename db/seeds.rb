# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Organization.create(name: "Carnegie Mellon University", active: true)
User.create(username: "minkyung", first_name: "Minkyung", last_name: "Lee", email: "test@test.com", phone: "1111111111", password: "secret", password_confirmation: "secret", role: "admin", organization_id: 1, active: true, job_title: "Researcher")

needs_list = [
	["food", "coffee"],
	["food", "canned goods"],
	["food", "sandwiches"],
	["food", "fruit"],
	["food", "water"],
	["food", "granola bars"],
	["food", "other"],
	["clothing", "jeans"],
	["clothing", "socks"],
	["clothing", "coats"],
	["clothing", "hats"],
	["clothing", "gloves"],
	["clothing", "blankets"],
	["clothing", "shoes"],
	["clothing", "boots"],
	["clothing", "underwear"],
	["clothing", "other"],
	["toiletries", "wet wipes"],
	["toiletries", "feminine care products"],
	["toiletries", "hand sanitizer"],
	["toiletries", "soap"],
	["toiletries", "deodorant"],
	["toiletries", "shampoo"],
	["toiletries", "lotion"],
	["toiletries", "toilet paper"],
	["toiletries", "other"],
	["camp", "trash bags"],
	["camp", "tents"],
	["camp", "sleeping bags"],
	["camp", "rope"],
	["camp", "tarp"],
	["camp", "tools"],
	["camp", "flash lights"],
	["camp", "batteries"],
	["camp", "other"],
	["transportation", "bikes"],
	["transportation", "bus tickets"],
	["transportation", "rides"],
	["transportation", "other"],
	["medical", "pregnancy care"],
	["medical", "prescription medication"],
	["medical", "non-prescription medication"],
	["medical", "first aid"],
	["medical", "other"],
	["other", "miscellaneous"],
]

needs_list.each do |category, name|
  Need.create( name: name, category: category )
end
