# Uncomment this if you reference any of your controllers in activate
require_dependency 'application_controller'

class MembersExtension < Radiant::Extension
  version "0.2.0"
  description "Extends Radiant user model for site members"
  url "http://cubiclemuses.com/cm"
  
  define_routes do |map|
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.resources :members, :collection => { :profile => :get }
      admin.resources :passwords, :collection => {:update_after_forgetting => :post}
    end
    map.forgot_password '/admin/forgot_password', :controller => 'admin/passwords', :action => 'new'
    map.change_password '/admin/change_password/:reset_code', :controller => 'admin/passwords', :action => 'reset'
  end
  
  def activate
    admin.tabs.add "Profile", "/admin/members/profile", :after => "Layouts", :visibility => [:all]
    
    User.class_eval do
      file_column :photo, :magick => { :geometry => "80x80>" }   
      validates_presence_of :email, :message => 'required'
      
      before_validation :sync_login_and_email

      def sync_login_and_email
        self.login = self.email
      end

    end

    Radiant::AdminUI::Tab.class_eval do

      alias_method :initialize_less_securely, :initialize unless method_defined?(:initialize_more_securely)
      
      def initialize_more_securely(name, url, options = {})
        @name, @url = name, url
        @visibility = [options[:for], options[:visibility]].flatten.compact
        @visibility = [:developer,:admin] if @visibility.empty?
      end      
      
      alias_method :initialize, :initialize_more_securely      
      
    end
    
    Admin::PagesController.class_eval do 
      only_allow_access_to :index, :new, :edit, :remove,
        :when => [:developer, :admin],
        :denied_url => { :controller => 'welcome', :action => 'index' },
        :denied_message => 'You must have developer privileges to perform this action.'        
    end
    
    Admin::SnippetsController.class_eval do 
      only_allow_access_to :index, :new, :edit, :remove,
        :when => [:developer, :admin],
        :denied_url => { :controller => 'welcome', :action => 'index' },
        :denied_message => 'You must have developer privileges to perform this action.'        
    end    
    
    # override login in order to add new links on the login form

    Admin::WelcomeController.class_eval do 
      alias_method :index_to_page, :index unless method_defined?(:index_to_profile)
      alias_method :login_without_links, :login unless method_defined?(:login_with_links)
      
      def index_to_profile
        redirect_to profile_admin_members_path
      end

      def login_with_links
        if request.post?
          login = params[:user][:login]
          password = params[:user][:password]
          announce_invalid_user unless self.current_user = User.authenticate(login, password)
        end
        if current_user
          if params[:remember_me]
            current_user.remember_me
            set_session_cookie
          end
          redirect_to (session[:return_to] || welcome_url)
          session[:return_to] = nil
        else
          render :template => 'admin/members/login.html.haml'
        end
      end
        
      
      alias_method :index, :index_to_profile
      alias_method :login, :login_with_links
      
    end    
    
    
  end
  
  def deactivate
    admin.tabs.remove "Profile"
  end
  
end
