class Initial < ActiveRecord::Migration[5.0]
  def change
    create_table :task_lists do |t|
      t.string :name
      t.string :slug
      t.timestamps
    end

    create_table :tasks  do |t|
      t.string :description
      t.string :state
      t.integer :progress_state
      t.integer :priority
      t.integer :lock_version
      t.date :start_date 
      t.date :end_date 
      t.string :type
      t.timestamps
      t.references :task_list, foreign_key: true
    end
    
    add_index :task_lists, :slug, unique: true
  end
end
