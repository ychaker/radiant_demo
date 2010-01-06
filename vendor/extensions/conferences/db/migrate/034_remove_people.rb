class RemovePeople < ActiveRecord::Migration
  
  def self.up
    populate_users(Presentation)
    populate_users(Activity)
    populate_users(PanelMember)
    
    remove_column :users, :person_id
    remove_column :activities, :person_id
    remove_column :panel_members, :person_id
    remove_column :presentations, :person_id
        
    drop_table :people    

    puts "recreating conference_roles view..."

    execute "DROP VIEW conference_roles"
    
    mysql_version = <<SQL

CREATE VIEW `conference_roles` AS select concat(_latin1'2',`tracks`.`conference_id`,`presentations`.`presenter_id`,`scheduled_sessions`.`id`) AS `id`,`tracks`.`conference_id` AS `conference_id`,`presentations`.`presenter_id` AS `presenter_id`,`scheduled_sessions`.`id` AS `event_id`,_latin1'scheduled_session' AS `event_type` from (((`tracks` join `scheduled_sessions`) join `submissions`) join `presentations`) where ((`tracks`.`id` = `scheduled_sessions`.`track_id`) and (`scheduled_sessions`.`submission_id` = `submissions`.`id`) and (`submissions`.`presentation_id` = `presentations`.`id`)) 
union select concat(_latin1'3',`activities`.`conference_id`,`activities`.`presenter_id`,`activities`.`id`) AS `id`,`activities`.`conference_id` AS `conference_id`,`activities`.`presenter_id` AS `presenter_id`,`activities`.`id` AS `event_id`,_latin1'activity' AS `event_type` from `activities` 
union select concat(_latin1'4',`tracks`.`conference_id`,`panel_members`.`presenter_id`,`scheduled_sessions`.`id`) AS `id`,`tracks`.`conference_id` AS `conference_id`,`panel_members`.`presenter_id` AS `presenter_id`,`scheduled_sessions`.`id` AS `event_id`,_latin1'panel_member' AS `event_type` from ((((`tracks` join `scheduled_sessions`) join `submissions`) join `panel_members`) join `users`) where ((`tracks`.`id` = `scheduled_sessions`.`track_id`) and (`scheduled_sessions`.`submission_id` = `submissions`.`id`) and (`panel_members`.`submission_id` = `submissions`.`id`))

SQL

     execute mysql_version
    
  end
  

  def self.populate_users(model)
    models = model.find(:all)
    models.each do | m |
      person_id = m.person_id
      if person_id
        user_id = Person.find(person_id).user_id
        puts "#{m.id} ; #{m.person_id} ; #{user_id}" 
        m.presenter_id = user_id
        m.person_id = nil
        m.save!        
      else
        puts "no person_id for #{m.to_s} : #{m.id}" unless person_id
      end
    end
  end    

  
end
