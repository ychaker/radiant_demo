# Uncomment this if you reference any of your controllers in activate
# require_dependency 'application'

require File.dirname(__FILE__) + "/lib/acts_as_cache_clearing"

class ConferencesExtension < Radiant::Extension
  version "0.2.0"
  description "Manage conference events, speakers, presentations and tracks."
  url "http://cubiclemuses.com/cm"

  define_routes do |map|
    
    map.namespace :admin, :member => { :remove => :get } do |admin|
      admin.namespace :con do |con|
        con.resources :conferences, :active_scaffold => true do |conferences| 
          conferences.resources :activities, :active_scaffold => true
          conferences.resources :tracks, :active_scaffold => true
          conferences.resources :conference_roles, :active_scaffold => true, :collection => {:compose => :get, :email => :post, :report => :get}
          conferences.resources :panel_members, :active_scaffold => true
          conferences.resources :scheduled_sessions, :active_scaffold => true
          conferences.resources :speakers, :active_scaffold => true
          conferences.resources :sponsors, :active_scaffold => true
          conferences.resources :submissions, :active_scaffold => true, :collection => {:report => :get}
        end
        con.resources :sponsor_levels, :active_scaffold => true
        con.resources :sponsor_types, :active_scaffold => true
        con.resources :session_types, :active_scaffold => true
        con.resources :presentation_types, :active_scaffold => true
        con.resources :venues, :active_scaffold => true
        con.resources :locations, :active_scaffold => true
        con.resources :organizations, :active_scaffold => true
        con.resources :presentations, :active_scaffold => true
        con.resources :users, :active_scaffold => true
        con.resources :cfp
      end
    end


    map.connect 'admin/con', :controller => 'admin/con/dashboard', :action => 'index'
    map.connect 'admin/con/dashboard/:action/:id', :controller => 'admin/con/dashboard'

  end

  def activate
    
    admin.tabs.add "Conferences", "/admin/con", :before => "Pages", :visibility => [:developer, :admin]
    admin.tabs.add "Submissions", "/admin/con/cfp", :before => "Conferences", :visibility => [:all]    

    ActiveRecord::Base.send(:include, Con::CacheClearing)
    Page.send :include, ConferenceTags    
    
    User.class_eval {

      acts_as_cache_clearing      
      
      has_many :conference_roles, :foreign_key => 'presenter_id'
      has_many :conferences, :through => :conferences_roles, :foreign_key => 'presenter_id'
      has_many :presentations, :foreign_key => 'presenter_id'
      has_many :panel_members, :foreign_key => 'presenter_id'
      has_many :submissions, :through => :presentations
      has_many :activities, :foreign_key => 'presenter_id'

      def scheduled_sessions(conference=nil, include_panels=true)
        sessions = [ ]
        conference_roles.each do |role|
          inc = true
          if conference
            inc = role.conference == conference
          end
          
          case role.session
            when ScheduledSession then sessions << role.session if inc
            when PanelMember
              if include_panels and inc
                sessions << role.session.submission.scheduled_session
              end
           end
         end
        return sessions
      end  
      
    }


    SpeakersPage
    SpeakerPage
    SponsorsPage
    SponsorTypePage
    SchedulePage
    ScheduleDayPage
    SessionsPage
    SessionPage
  end

  def deactivate
     admin.tabs.remove "Conferences"
  end

end
