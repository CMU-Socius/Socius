require './test/test_helper'

class PostNeedTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  should belong_to(:post)
  should belong_to(:need)
end
