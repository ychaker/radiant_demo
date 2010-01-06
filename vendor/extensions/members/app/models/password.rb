# from http://github.com/fudgestudios/bort/tree/master
# Licensed under MIT license
# Copyright 2008 Jim Neath

require 'digest/sha1'

class Password < ActiveRecord::Base
  attr_accessor :email
  
  # Relationships
  belongs_to :user
  
  # Validations
  validates_presence_of :email, :user

  protected
  
  def before_create
    self.reset_code = Digest::SHA1.hexdigest(Time.now.to_s.split(//).sort_by {rand}.join )
    self.expiration_date = 2.weeks.from_now
  end
end
