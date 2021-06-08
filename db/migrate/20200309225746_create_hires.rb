class CreateHires < ActiveRecord::Migration
  def change
    create_table :hires do |t|
      t.references :job, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.references :state, index: true, foreign_key: true, :default=>1
      t.datetime :reg_date, :default => Time.now
      t.string :bid_content
      t.integer :invitation_read, :default=>0

      t.timestamps null: false
    end
  end
end
