# Clear existing data
User.destroy_all
Travel.destroy_all
Comment.destroy_all

# Create users
user1 = User.create!(
  email: "user1@example.com",
  password: "password",
  first_name: "Traverse",
  last_name: "Test"
)

user2 = User.create!(
  email: "user2@example.com",
  password: "password",
  first_name: "Jane",
  last_name: "Smith"
)

# Create travels
travel1 = Travel.create!(
  name: "Skyrim",
  start_date: Date.new(2023, 1, 1),
  end_date: Date.new(2023, 1, 10),
  favorite: true,
  user: user1,
  created_at: 1.day.ago,
  updated_at: 1.day.ago
)

travel1.images.attach(io: File.open(Rails.root.join('db/images/winterhold1.jpg')),
filename: 'winterhold.jpg')
travel1.images.attach(io: File.open(Rails.root.join('db/images/riften1.jpg')),
filename: 'winterhold.jpg')
travel1.images.attach(io: File.open(Rails.root.join('db/images/markarth.jpg')),
filename: 'winterhold.jpg')

travel2 = Travel.create!(
  name: "Cat Cafe",
  start_date: Date.new(2023, 2, 15),
  end_date: Date.new(2023, 2, 25),
  favorite: false,
  user: user2,
  created_at: Time.now,
  updated_at: Time.now
)

travel2.images.attach(io: File.open(Rails.root.join('db/images/cat1.jpg')),
filename: 'winterhold.jpg')
travel2.images.attach(io: File.open(Rails.root.join('db/images/cat2.jpg')),
filename: 'winterhold.jpg')
travel2.images.attach(io: File.open(Rails.root.join('db/images/cat3.jpg')),
filename: 'winterhold.jpg')

# Create comments
Comment.create!(
  body: "comment1",
  commentable: travel1,
  user: user1,
  created_at: 1.day.ago,
  updated_at: 1.day.ago
)

Comment.create!(
  body: "comment2!",
  commentable: travel2,
  user: user2,
  created_at: Time.now,
  updated_at: Time.now
)

puts "Seed data created successfully!"
