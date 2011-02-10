require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead.
  # Then, you can remove it from this and the functional test.
  include AuthenticatedTestHelper
  fixtures :students

  def test_should_create_student
    assert_difference 'Student.count' do
      student = create_student
      assert !student.new_record?, "#{student.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'Student.count' do
      u = create_student(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'Student.count' do
      u = create_student(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'Student.count' do
      u = create_student(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end

  def test_should_require_email
    assert_no_difference 'Student.count' do
      u = create_student(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    students(:quentin).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal students(:quentin), Student.authenticate('quentin', 'new password')
  end

  def test_should_not_rehash_password
    students(:quentin).update_attributes(:login => 'quentin2')
    assert_equal students(:quentin), Student.authenticate('quentin2', 'monkey')
  end

  def test_should_authenticate_student
    assert_equal students(:quentin), Student.authenticate('quentin', 'monkey')
  end

  def test_should_set_remember_token
    students(:quentin).remember_me
    assert_not_nil students(:quentin).remember_token
    assert_not_nil students(:quentin).remember_token_expires_at
  end

  def test_should_unset_remember_token
    students(:quentin).remember_me
    assert_not_nil students(:quentin).remember_token
    students(:quentin).forget_me
    assert_nil students(:quentin).remember_token
  end

  def test_should_remember_me_for_one_week
    before = 1.week.from_now.utc
    students(:quentin).remember_me_for 1.week
    after = 1.week.from_now.utc
    assert_not_nil students(:quentin).remember_token
    assert_not_nil students(:quentin).remember_token_expires_at
    assert students(:quentin).remember_token_expires_at.between?(before, after)
  end

  def test_should_remember_me_until_one_week
    time = 1.week.from_now.utc
    students(:quentin).remember_me_until time
    assert_not_nil students(:quentin).remember_token
    assert_not_nil students(:quentin).remember_token_expires_at
    assert_equal students(:quentin).remember_token_expires_at, time
  end

  def test_should_remember_me_default_two_weeks
    before = 2.weeks.from_now.utc
    students(:quentin).remember_me
    after = 2.weeks.from_now.utc
    assert_not_nil students(:quentin).remember_token
    assert_not_nil students(:quentin).remember_token_expires_at
    assert students(:quentin).remember_token_expires_at.between?(before, after)
  end

protected
  def create_student(options = {})
    record = Student.new({ :login => 'quire', :email => 'quire@example.com', :password => 'quire69', :password_confirmation => 'quire69' }.merge(options))
    record.save
    record
  end
end
