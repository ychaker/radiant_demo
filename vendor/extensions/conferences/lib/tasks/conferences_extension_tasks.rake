require 'yaml'

namespace :radiant do
  namespace :extensions do
    namespace :conferences do

      desc "Runs the migration of the Conferences extension"
      task :migrate => :environment do
        require 'radiant/extension_migrator'
        if ENV["VERSION"]
          ConferencesExtension.migrator.migrate(ENV["VERSION"].to_i)
        else
          ConferencesExtension.migrator.migrate
        end
      end

      desc "Copies public assets of the Conferences to the instance public/ directory."
      task :update => :environment do
        is_svn_or_dir = proc {|path| path =~ /\.svn/ || File.directory?(path) }
        Dir[ConferencesExtension.root + "/public/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ConferencesExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          cp file, RAILS_ROOT + path
        end
        # copy active_scaffold
        Dir[ConferencesExtension.root + "/vendor/plugins/active_scaffold/**/*"].reject(&is_svn_or_dir).each do |file|
          path = file.sub(ConferencesExtension.root, '')
          directory = File.dirname(path)
          puts "Copying #{path}..."
          mkdir_p RAILS_ROOT + directory
          mv file, RAILS_ROOT + path
        end
      end

      desc "Consolidates all user accounts and replaces login with email"
      task :merge_users => :environment do
        results = User.connection.execute <<SQL 
               select email, count 
                from (select email, count(id) as 'count' from users group by email) as emails 
                where count > 1 and count < 20
SQL
        results.each do |res|
          email = res[0]
          users = User.find(:all, :conditions => ['email = ?',email])
          if users.size > 1            
            master_user = users[0]
            logins = Array.new
            users.each do |user|
              unless user.id == master_user.id
                
                logins << user.login

                user.presentations.each   {|p| p.presenter_id = master_user.id; p.save}
                user.panel_members.each   {|p| p.presenter_id = master_user.id; p.save}
                user.activities.each      {|a| a.presenter_id = master_user.id; a.save}
                
                user.destroy
              end
            end
            puts "combined accounts for #{master_user.login} <#{master_user.email}>, AKA #{logins.join(',')}"
          end
        end
        
        users = User.find(:all)
        users.each do |user|
          unless user.email == 'info@apachecon.com'
            puts "combining login and email for #{user.login} <#{user.email}>"            
            user.login = user.email
            user.save
          end
        end
        
      end     
    end
  end
end
