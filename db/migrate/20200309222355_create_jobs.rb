class CreateJobs < ActiveRecord::Migration
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.references :category, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.datetime :reg_date, :default => Time.now
      t.references :state, index: true, foreign_key: true, :default=>1
      t.string :skills
      t.timestamps null: false
    end
  end
end
