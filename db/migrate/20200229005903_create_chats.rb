class CreateChats < ActiveRecord::Migration
  def change
    create_table :chats do |t|
      t.string :content
      t.references :user, index: true, foreign_key: true
      t.references :hire, index: true, foreign_key: true
      t.references :job, index: true, foreign_key: true
      t.integer    :read, :default=> 0
      
      t.timestamps null: false
    end
  end
end
