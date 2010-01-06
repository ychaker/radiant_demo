class Admin::MembersController < Admin::ResourceController

  model_class User

  skip_before_filter :authenticate, :only => [:new, :create ]
  skip_before_filter :authorize,    :only => [:new, :create ]

#  skip_before_filter :verify_authenticity_token, :only => [:new,:create]

  def profile
    redirect_to edit_admin_member_path(current_user.id)
  end

  def index
    redirect_to edit_admin_member_path(current_user.id)
  end

  def new
    self.model = model_class.new
    render :template =>  'admin/members/new.html.haml'
  end

end
