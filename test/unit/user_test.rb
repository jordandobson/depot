require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @user = User.new
    @a_user = users(:jordan)
  end
  
end