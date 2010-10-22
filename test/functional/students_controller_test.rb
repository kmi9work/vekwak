require File.dirname(__FILE__) + '/../test_helper'
require 'students_controller'

# Re-raise errors caught by the controller.
class StudentsController; def rescue_action(e) raise e end; end

class StudentsControllerTest < ActionController::TestCase
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
  include AuthenticatedTestHelper

  fixtures :students

  def test_should_allow_signup
    assert_difference 'Student.count' do
      create_student
      assert_response :redirect
    end
  end

  def test_should_require_login_on_signup
    assert_no_difference 'Student.count' do
      create_student(:login => nil)
      assert assigns(:student).errors.on(:login)
      assert_response :success
    end
  end

  def test_should_require_password_on_signup
    assert_no_difference 'Student.count' do
      create_student(:password => nil)
      assert assigns(:student).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'Student.count' do
      create_student(:password_confirmation => nil)
      assert assigns(:student).errors.on(:password_confirmation)
      assert_response :success
    end
  end

  def test_should_require_email_on_signup
    assert_no_difference 'Student.count' do
      create_student(:email => nil)
      assert assigns(:student).errors.on(:email)
      assert_response :success
    end
  end
  

  

  protected
    def create_student(options = {})
      post :create, :student => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire69', :password_confirmation => 'quire69' }.merge(options)
    end
end
