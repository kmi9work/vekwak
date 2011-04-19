class Huser < ActiveRecord::Base
  attr_accessor :password_confirmation
  validates_presence_of     :login
  validates_length_of       :login,    :within => 3..30
  validates_uniqueness_of   :login
end
