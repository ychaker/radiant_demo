class Email < ActiveRecord::Base

  belongs_to :conference

  def recipients
   return ['Speakers','Unaccepted Submitters','All']
  end

  def send
    self.save
    
  end

end
