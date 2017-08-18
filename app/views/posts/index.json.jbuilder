
json.posts @posts do |post|
  json.latitude post.latitude
  json.longitude post.longitude
  json.street_1 post.street_1
  json.street_2 post.street_2
  json.zip post.zip
  json.city post.city
  json.state post.state
  json.date_posted post.date_posted
  json.date_completed post.date_completed
  json.number_people post.number_people
  json.poster post.poster.proper_name
  json.claimer_id post.claimer_id

  json.post_needs post.post_needs do |post_need|
    json.need post_need.need.name
    json.time_completed post_need.time_completed
  end

end