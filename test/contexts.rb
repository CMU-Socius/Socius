# require needed files
require './test/sets/users'
require './test/sets/posts'
require './test/sets/user_posts'
require './test/sets/organizations'
require './test/sets/needs'
require './test/sets/post_needs'

module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::Users
  include Contexts::Posts
  include Contexts::UserPosts
  include Contexts::Organizations
  include Contexts::SchoNeeols
  include Contexts::Needs
  include Contexts::PostNeeds
end