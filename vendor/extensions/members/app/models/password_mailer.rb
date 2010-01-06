# from http://github.com/fudgestudios/bort/tree/master
# Licensed under MIT license
# Copyright 2008 Jim Neath

class PasswordMailer < ActionMailer::Base

  # IMPORTANT!!! be sure to change the addresses and site names below

  def forgot_password(password)
    setup_email(password.user)
    @subject << 'You have requested to change your password'
    @body[:url] = "http://localhost:3000/admin/change_password/#{password.reset_code}"
  end

  def reset_password(user)
    setup_email(user)
    @subject << 'Your password has been reset.'
  end

  protected
  
  def setup_email(user)
    @recipients = "#{user.email}"
    @from =  'admin@localhost' 
    @subject = '[RADIANT CMS] '
    @sent_on = Time.now
    @body[:user] = user
  end
end
