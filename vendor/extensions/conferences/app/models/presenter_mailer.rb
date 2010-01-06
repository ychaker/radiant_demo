class PresenterMailer < ActionMailer::Base
  

  def notification presenter, submission, title, content
    recipients presenter.email
    subject title
    # configure this via conference
    from "planners@apachecon.com"
    body content
    
  end

end
