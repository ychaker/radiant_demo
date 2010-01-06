class CreateEmails < ActiveRecord::Migration
  def self.up
    create_table :emails do |t|
      t.integer :conference_id      
      t.string :recipient
      t.string :subject
      t.text :body

      t.timestamps
    end
  end

  def self.down
    drop_table :emails
  end
end