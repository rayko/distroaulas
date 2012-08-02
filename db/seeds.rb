# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

puts 'Creating first user...'
User.create :email => 'admin@example.com', :username => 'admin', :full_name => 'Main Administrator', :role => 'admin', :password => 'superadmin', :password_confirmation => 'superadmin'

puts 'First user created!'
puts 'Mail: admin@example.com'
puts 'Username: admin'
puts 'Pass: superadmin'
puts '---'
puts 'Use the credentials avobe to access Distroaulas for the first time.'
puts 'It\'s highly recommended to delete the first user or at least change the password for better security.'
