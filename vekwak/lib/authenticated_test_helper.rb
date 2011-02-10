module AuthenticatedTestHelper
  # Sets the current student in the session from the student fixtures.
  def login_as(student)
    @request.session[:student_id] = student ? (student.is_a?(Student) ? student.id : students(student).id) : nil
  end

  def authorize_as(student)
    @request.env["HTTP_AUTHORIZATION"] = student ? ActionController::HttpAuthentication::Basic.encode_credentials(students(student).login, 'monkey') : nil
  end
  
end
