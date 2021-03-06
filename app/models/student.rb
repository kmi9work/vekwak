require 'digest/sha1'

class Student < ActiveRecord::Base
  include Authentication
  include Authentication::ByPassword
  include Authentication::ByCookieToken
  

  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..40
  validates_uniqueness_of   :login
  validates_format_of       :login,    :with => Authentication.login_regex, :message => Authentication.bad_login_message

  validates_format_of       :name,     :with => Authentication.name_regex,  :message => Authentication.bad_name_message, :allow_nil => true
  validates_length_of       :name,     :maximum => 100

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email
  validates_format_of       :email,    :with => Authentication.email_regex, :message => Authentication.bad_email_message

  

  # HACK HACK HACK -- how to do attr_accessible from here?
  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :name, :password, :password_confirmation, :group, :last_name, :second_name, :karma, :rating, :avatar

  has_many :posts, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :post_rating_students, :dependent => :destroy
  has_many :comment_rating_students, :dependent => :destroy
  has_many :days, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :novelties, :dependent => :destroy  
  has_attached_file :avatar, 
                    :styles => SIZES,
                    :default_url => "/system/images/missing_:style.png",
                    :url => "/system/images/:class/:attachment/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/:url",
                    :convert_options => {:offline => "-auto-orient -modulate 100,0"}

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  #
  # uff.  this is really an authorization, not authentication routine.  
  # We really need a Dispatch Chain here or something.
  # This will also let us return a human error message.
  #
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    u = find_by_login(login.downcase) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  def login=(value)
    write_attribute :login, (value ? value.downcase : nil)
  end

  def email=(value)
    write_attribute :email, (value ? value.downcase : nil)
  end
  
  def record_last_visit
    self.prev_visit = self.last_visit
    ActiveRecord::Base.connection.execute("update students set last_visit = '#{Time.zone.now}' where id = #{id}")
  end 
  
  def online?(max_delay=5.minutes)
    last_visit && (Time.now - last_visit < max_delay)
  end


  protected
    


end
