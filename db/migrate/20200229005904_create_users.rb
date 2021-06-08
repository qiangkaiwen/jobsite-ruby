class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.string :salt
      t.string :image_url
      t.string :location
      t.string :skill, :default=>' '
      t.string :role , :default=> "user"
      t.integer :used , :default=> 0
      t.string :address, :default=>''

      t.timestamps null: false
    end
  end
end
