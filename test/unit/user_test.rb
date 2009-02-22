require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @new = User.new
    @fix = users(:jordan)
  end

  test "must find user by name" do
    @user = User.find_by_name("jordan")
    assert_equal "jordan", @user.name
  end
 
  test "fail authentication on bad password" do
    assert ! User.authenticate("jordan", "fail")
  end

  test "must authenticate" do
    assert User.authenticate("jordan", "dobson")
  end

  test "user must have name" do
    assert ! @new.valid?
    assert @new.errors.on(:name)
  end

  test "user must have name that is unique" do
    u = User.new(@fix.attributes)
    assert ! u.valid?
    assert u.errors.on(:name)
  end

  test "user must have password" do
    @new.name = "flower"
    assert_raise(ActiveRecord::RecordInvalid){
       @new.save!
    }
    assert ! @new.valid?
  end

  # should this also be in Controller tests?
  test "should not destroy last user account" do
    assert_raise RuntimeError do
      @users = User.find(:all)
      for user in @users
        user.destroy
      end
    end
  end

end