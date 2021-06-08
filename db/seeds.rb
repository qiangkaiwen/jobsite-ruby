# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

User.delete_all
# . . .
User.create(:name =>'master', :password => '0960c06094d5344aef0a8a83989e6a3f902798e39c5eb75e0fae568ebe571e14', :salt => 'I7Gzz4NF', :image_url => '부끄러워요.gif', :location => 'hello! I love programming.', :role => 'admin', :used=>1)

# . . .

Category.delete_all
# . . .
Category.create(:category_name =>'Ruby on Rails')
Category.create(:category_name =>'ReactJS')
Category.create(:category_name =>'Angular')
Category.create(:category_name =>'Android')
# . . .


State.delete_all
# . . .
State.create(:state_name =>'New', :state_color =>'success')
State.create(:state_name =>'Finished', :state_color =>'warning')
State.create(:state_name =>'Hired', :state_color =>'primary')
State.create(:state_name =>'Suspend', :state_color =>'danger')
State.create(:state_name =>'Invitation', :state_color =>'')


# . . .

Job.delete_all
# . . .


Hire.delete_all
# . . .

# . . .

Chat.delete_all
# . . .

# . . .
