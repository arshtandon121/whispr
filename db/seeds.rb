# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user
admin = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.admin = true
end

puts "Admin user created:"
puts "Email: admin@example.com"
puts "Password: password123"
puts "\nYou can use these credentials to log in and access the admin panel at /admin/confessions"

# Create some sample confessions if none exist
if Confession.count == 0
  10.times do |i|
    Confession.create!(
      body: "Sample confession #{i + 1} - This is a test confession created by the seed file.",
      ip_address: "127.0.0.1"
    )
  end
  puts "\nCreated 10 sample confessions"
end
